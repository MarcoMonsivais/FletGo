'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const { Logging } = require('@google-cloud/logging');
const logging = new Logging();
const stripe = require('stripe')(functions.config().stripe.token);
const currency = functions.config().stripe.currency || 'MXN';

// [START chargecustomer]
// Realizar cargo al Stripe customer cuando una cantidad sea escrita en Realtime database
exports.createStripeCharge = functions.firestore.document('stripe_customers/{userId}/charges/{id}').onCreate(async (snap, context) => {
    const val = snap.data();
    try {
        // Stripe customer id escrito en createStripeCustomer
        const snapshot = await admin.firestore().collection(`stripe_customers`).doc(context.params.userId).get()
        const snapval = snapshot.data();
        const customer = snapval.customer_id

        // Crear un cargo usando el pushId como idempotency key
        // protegiendo contra doble cargo
        const amount = val.amount;
        const idempotencyKey = context.params.id;
        const charge = { amount, currency, customer };
        if (val.source !== null) {
            charge.source = val.source;
        }
        const response = await stripe.charges.create(charge, { idempotency_key: idempotencyKey });
        // Resultado exitoso, escribir en la base de datos
        return snap.ref.set(response, { merge: true });
    } catch (error) {
        // Capturar errores y renderizar en user-friendly
        // creando un log con StackDriver
        console.log(error);
        await snap.ref.set({ error: userFacingMessage(error) }, { merge: true });
        return reportError(error, { user: context.params.userId });
    }
});
// [END chargecustomer]]

// Cuando un usuario es creado, registrarlo con Stripe
exports.createStripeCustomer = functions.auth.user().onCreate(async (user) => {
    const customer = await stripe.customers.create({ email: user.email });
    return admin.firestore().collection('stripe_customers').doc(user.uid).set({ customer_id: customer.id });
});

// Agregar un payment source (card) para un usuario al escribir un stripe payment source token en Realtime db
exports.addPaymentSource = functions.firestore.document('/stripe_customers/{userId}/tokens/{pushId}').onCreate(async (snap, context) => {
    const source = snap.data();
    const token = source.tokenId;
    if (source === null) {
        return null;
    }

    try {
        const snapshot = await admin.firestore().collection('stripe_customers').doc(context.params.userId).get();
        const customer = snapshot.data().customer_id;
        const response = await stripe.paymentMethods.attach(token, {customer: customer });
        return admin.firestore()
            .collection('stripe_customers')
            .doc(context.params.userId)
            .collection("sources")
            .doc(response.card.fingerprint).set(response.card, { merge: true });
    } catch (error) {
        await snap.ref.set({ 'error': userFacingMessage(error) }, { merge: true });
        return reportError(error, { user: context.params.userId });
    }
});

// Cuando un usuario borra su cuenta, clean up after them
exports.cleanupUser = functions.auth.user().onDelete(async (user) => {
    const snapshot = await admin.firestore().collection('stripe_customers').doc(user.uid).get();
    const customer = snapshot.data();
    await stripe.customers.del(customer.customer_id);
    return admin.firestore().collection('stripe_customers').doc(user.uid).delete();
});

// Para errores, debemos levantar un reporte de error detallado con Stackdriver en vez de 
// solo basarse en console.error. Esto calcula los usuarios afectados + te envia alerta de email
// [START reporterror]
function reportError(err, context = {}) {
    // Este es el nombre del StackDriver log stream que recibe el log entry.
    // Puede ser cualquier nombre pero debe contener "err" para ser tratado como un error
    // por el StackDriver Error Reporting. 
    const logName = 'errors';
    const log = logging.log(logName);

    // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
    const metadata = {
        resource: {
            type: 'cloud_function',
            labels: { function_name: process.env.FUNCTION_NAME },
        },
    };

    // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
    const errorEvent = {
        message: err.stack,
        serviceContext: {
            service: process.env.FUNCTION_NAME,
            resourceType: 'cloud_function',
        },
        context: context,
    };

    // Write the error log entry
    return new Promise((resolve, reject) => {
        log.write(log.entry(metadata, errorEvent), (error) => {
            if (error) {
                return reject(error);
            }
            return resolve();
        });
    });
}
// [END reporterror]

// Mensaje de error para el usuario
function userFacingMessage(error) {
    return error.type ? error.message : 'Ha ocurrido un error, el equipo ha sido alertado.';
}