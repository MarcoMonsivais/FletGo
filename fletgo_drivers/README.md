# Aplicacion de usuarios y conductores

## Tecnologias utilizadas
### Flutter
La aplicacion esta creada en Flutter para Android y iOS. La documentacion de este framework esta en:
http://flutter.dev/

También, se tienen varios plugins instalados disponibles en el archivo: pubspec.yml

### Base de datos Firebase
Como base de datos, se utiliza Firebase pues la integracion con Flutter es muy sencilla y rapida. 
Para acceder a Firebase se utiliza la cuenta de Gmail: fletgodev@gmail.com con su respectiva contraseña.
El link del proyecto de base de datos es el siguiente: https://console.firebase.google.com/u/3/project/fletgo-8ce42/overview

### Cloud Functions Firebase
Se utilizan varias Cloud Functions de Firebase para automatizar tareas en el fondo. Estan programadas en Node JS y se encuentran en la carpeta functions del repositorio (en la rama 1.x) 
https://github.com/fletgo/fletgo_user_app/tree/1.x/functions

### Stripe Account
La aplicación tiene utiliza la plataforma de Stripe para pagos. No se ha realizado la integracion para realizar cargos a tarjetas pero si se añadió la opción para agregar o eliminar tarjetas del usuario. 

Gran parte de esta funcionalidad se hace con Google Cloud Functions de Firebase que estan programadas en Javascript.

### Creacion de ordenes
Se trata de mantener el proceso de crear una orden lo mas sencillo posible. Se crearon dos pantallas para escribir indicaciones de partida y llegada. Falta agregar una mas para instrucciones del vehiculo.

### Google Play Store
La aplicacion esta en proceso de "Internal release" en la Google Play Store. Para ver y completar el proceso referirse al siguiente link: 
https://play.google.com/apps/publish
Y acceder con la cuenta de Gmail: fletgodev@gmail.com con su respectiva contraseña.

## Actividades realizadas y por realizar
- [x] Autenticacion con Google (plugin: firebase_auth, google_sign_in)
- [x] Al iniciar sesion por primera vez, mediante una Google Cloud Function se asocia un Stripe ID al usuario. Esto para conectar nuestra base de datos, Firebase, con la plataforma de Stripe.
- [x] Manejo de state a traves de la app (plugin: rxdart)
- [x] Diseño de la vista de mapa utilizando plugins de geolocalizacion y renderizado de mapas para Flutter (plugin: flutter_google_maps, geolocation, flutter_google_places)
- [x] Insertar direcciones (partida y destino) utilizando Google Maps API y el plugin de busqueda de direcciones para Flutter (google_maps_webservice)
- [x] Dibujar polyline en el mapa al seleccionar direcciones (plugin: google_map_polyline)
- [x] Listar tarjetas de credito y debido de la cuenta del usuario mediante Stripe (plugin: stripe_payment, cloud_firestore)
- [x] Poder eliminar tarjetas de credito de la cuenta de usuario y de la cuenta en la plataforma Stripe (plugin: stripe_payment, cloud_firestore)
- [x] En el proceso de crear una nueva orden, se hicieron inputs para indicaciones de partida y de entrega.
- [x] Terminar la orden y guardar la informacion en Firestore (plugin: cloud_firestore)
- [ ] En el proceso de crear una nueva orden, se debe crear una pantalla despues de las "Indicaciones" que permita seleccionar las caracteristicas del vehiculo que se necesita (enfriamiento ON/OFF, tamaño y peso de la carga, tipo de vehiculo: pick up, trailer, entre otros requisitos)
- [ ] Se debe crear una nueva pestaña o vista para ver las ordenes "en espera de ser tomadas" que otros usuarios crearon. Aqui tambien se muestran las caracteristicas como PRECIO a pagar. 
- [ ] Al crear una orden se debe hacer un cargo o "hold" en la cuenta del usuario. Esto mediante una Cloud Function usando la SDK de Stripe. (Mas informacion referirse a documentación: https://stripe.com/docs/charges/placing-a-hold )
- [ ] En la pantalla de ordenes de otros usuarios, se debe poder seleccionar una orden "en espera" y tomarla.
- [ ] Al tomar la orden, se debe poder abrir un chat del usuario que tomo la orden y el usuario que envía. Esto se puede realizar usando Firebase Realtime Database. 
- [ ] En la vista historial, listar las ordenes con los detalles desde Firebase Firestore.
- [ ] En la vista perfil, mostrar la informacion basica del usuario. (No es necesario que la pueda editar, en tal caso, poner un boton "Contactanos" para que puedan enviar un email y se cambie su información manualmente por un agente de Soporte de Fletgo)

