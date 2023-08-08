import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/places.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  FirebaseUser user;
  String typeTravel;
  Address from;
  Details detailspick;
  Address to;
  Details detailsdrop;
  String kmDistance;
  String pickUpInstructions;
  String dropOffInstructions;
  Package package;
  String createdAt;
  String updatedAt;
  String tarifa;

  Order({
    this.user,
    this.typeTravel,
    this.from,
    this.detailspick,
    this.to,
    this.detailsdrop,
    this.kmDistance,
    this.pickUpInstructions,
    this.dropOffInstructions,
    this.package,
    this.createdAt,
    this.updatedAt,
    this.tarifa
  });

  factory Order.fromJson(Map<String, dynamic> json) => new Order(
        typeTravel: json["typeTravel"],
        from: Address.fromJson(json["from"]),
        detailspick: Details.fromJson(json["detailspick"]),
        to: Address.fromJson(json["to"]),
        detailsdrop: Details.fromJson(json["detailsdrop"]),
        package: Package.fromJson(json["package"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  factory Order.fromDocumentSnapshot(DocumentSnapshot document) => new Order(
      from: Address(
          description: document['pickUpAddress']['description'],
          gId: document['pickUpAddress']['gId'],
          gPlaceId: document['pickUpAddress']['gPlaceId'],
          mainText: document['pickUpAddress']['mainText'],
          secondaryText: document['pickUpAddress']['secondaryText']),
      detailspick: Details(
        name: document['name']['name'],
        description: document['description']['description'],
        date: document['date']['date'],
        hour1: document['hour1']['hour1'],
        hour2: document['hour2']['hour2'],
      ),
      detailsdrop: Details(
        name: document['name']['name'],
        description: document['description']['description'],
        date: document['date']['date'],
        hour1: document['hour1']['hour1'],
        hour2: document['hour2']['hour2'],
      ),
      to: Address(
          description: document['dropOffAddress']['description'],
          gId: document['dropOffAddress']['gId'],
          gPlaceId: document['dropOffAddress']['gPlaceId'],
          mainText: document['dropOffAddress']['mainText'],
          secondaryText: document['dropOffAddress']['secondaryText']),
      pickUpInstructions: document['pickUpInstructions'],
      dropOffInstructions: document['dropOffInstructions']);

  Map<String, dynamic> toJson() => {
        "from": from.toJson(),
        "detailspick": detailspick.toJson(),
        "to": to.toJson(),
        "package": package.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Package {
  String description;
  double weight;
  String weightUnit;
  String size;
  String vehicleType;
  String imageUrl;
  File image;
  String isUrgent;

  Package({
    this.description,
    this.weight,
    this.weightUnit,
    this.imageUrl,
    this.image,
    this.isUrgent,
  });

  factory Package.fromJson(Map<String, dynamic> json) => new Package(
        imageUrl: json["imageUrl"],
        weight: json["weight"].toDouble(),
        weightUnit: json["weight_unit"],
      );

  Map<String, dynamic> toJson() => {
        "isUrgent": isUrgent,
        "imageUrl": imageUrl,
        "weight": weight,
        "weight_unit": weightUnit,
      };
}
