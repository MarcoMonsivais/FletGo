import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  String displayName;
  String email;
  Timestamp lastSeen;
  String photoURL;
  String uid;

  Profile({
    this.displayName,
    this.email,
    this.lastSeen,
    this.photoURL,
    this.uid
  });

  factory Profile.fromJson(Map<String, dynamic> json) => new Profile(
    displayName: json["displayName"],
    email: json["email"],
    lastSeen: json["lastSeen"],
    photoURL: json["photoURL"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "displayName": displayName,
    "email": email,
    "lastSeen": lastSeen,
    "photoURL": photoURL,
    "uid": uid
  };
}