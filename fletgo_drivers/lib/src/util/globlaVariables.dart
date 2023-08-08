import 'dart:io';

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

class car {

  String carColor;
  String carMar;
  String carModel;
  String carYear;
  String carId;
  String carSecure;
  String carSecureNumber;

  car({
    this.carColor,
    this.carMar,
    this.carModel,
    this.carYear,
    this.carId,
    this.carSecure,
    this.carSecureNumber,
  });

}

class driver {

  String driverId;
  String driverLicense;
  File selfie;
  File domicilio;
  File INE;
  File license;
  File seguro;
  String driverBirth;
  String driverHealthTest;

  driver({
    this.driverId,
    this.driverLicense,

    this.selfie,
    this.domicilio,
    this.INE,
    this.license,
    this.seguro,

    this.driverBirth,
    this.driverHealthTest,
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