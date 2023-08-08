// import 'package:google_maps_webservice/places.dart';

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
