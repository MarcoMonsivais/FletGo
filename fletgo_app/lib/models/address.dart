import 'package:google_maps_webservice/places.dart';

class Address {
  int id;
  String description;
  String gPlaceId;
  String gId;
  String mainText;
  String secondaryText;

  Address(
      {this.id,
      this.description,
      this.gPlaceId,
      this.gId,
      this.mainText,
      this.secondaryText});

  factory Address.fromJson(Map<String, dynamic> json) => new Address(
        id: json["id"],
        description: json["description"],
        gPlaceId: json["gPlaceId"],
        gId: json["gId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "gPlaceId": gPlaceId,
        "gId": gId,
      };
}

class Details {
  String description;
  String name;
  String date;
  String hour1;
  String hour2;
  String phoneContact;

  Details(
      {
        this.description,
        this.phoneContact,
        this.name,
        this.date,
        this.hour1,
        this.hour2
      });

  factory Details.fromJson(Map<String, dynamic> json) => new Details(
    name: json["name"],
    description: json["description"],
    date: json["date"],
    hour1: json["hour1"],
    hour2: json["hour2"],
    phoneContact: json["phoneContact"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "phoneContact": phoneContact,
    "date": date,
    "hour1": hour1,
    "hour2": hour2,
  };
}
