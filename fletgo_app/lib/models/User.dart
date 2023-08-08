class User {
  String uuid;
  String name;
  String fatherLastName;
  String motherLastName;
  String email;
  String password;
  String photo;

  User({
    this.email,
    this.fatherLastName,
    this.motherLastName,
    this.name,
    this.password,
    this.photo,
    this.uuid
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
    uuid: json["uuid"],
    name: json["name"],
    fatherLastName: json["father_last_name"],
    motherLastName: json["mother_last_name"],
    email: json["email"],
    password: json["password"],
    photo: json["photo"]
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "father_last_name": fatherLastName,
    "mother_last_name": motherLastName,
    "email": email,
    "password": password,
    "photo": photo
  };
}