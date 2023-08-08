class user {

  String userMail;
  String userPass;
  String userName;
  String userLastName;
  String userPhoneNumber;

  user({
    this.userMail,
    this.userPass,
    this.userName,
    this.userLastName,
    this.userPhoneNumber,
  });

}

class infoUser{

  String uuidUser;
  String mailUser;
  String passUser;

  infoUser({
    this.uuidUser,
    this.mailUser,
    this.passUser,
  });

}

class infoPayment{
  String methodId;
  String intentId;
  String currency;
  String amount;
  String description;

  infoPayment({
    this.methodId,
    this.intentId,
    this.currency,
    this.amount,
    this.description
  });
}

class keyConf {
  String SK_STRIPE_GLOBAL;
  String PK_STRIPE;
  String STRIPE_MERCHANTID;
  String STRIPE_ANDROIDPAYMODE;

  keyConf({
    this.PK_STRIPE,
    this.SK_STRIPE_GLOBAL,
    this.STRIPE_MERCHANTID,
    this.STRIPE_ANDROIDPAYMODE,
});

}