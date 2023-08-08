import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fletgo_user_app/models/address.dart';
// import 'package:google_maps_webservice/places.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  FirebaseUser user;
  Address from;
  Address to;
  String pickUpInstructions;
  String dropOffInstructions;
  Package package;
  String createdAt;
  String updatedAt;

  Order({
    this.user,
    this.from,
    this.to,
    this.pickUpInstructions,
    this.dropOffInstructions,
    this.package,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => new Order(
        from: Address.fromJson(json["from"]),
        to: Address.fromJson(json["to"]),
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
  String enfriamiento;
  double size;
  String vehicleType;

  Package({
    this.description,
    this.weight,
    this.weightUnit,
  });

  factory Package.fromJson(Map<String, dynamic> json) => new Package(
        description: json["description"],
        weight: json["weight"].toDouble(),
        weightUnit: json["weight_unit"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "weight": weight,
        "weight_unit": weightUnit,
      };
}
