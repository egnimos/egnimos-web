import 'package:egnimos/src/utility/enum.dart';

class User {
  final String id;
  final String name;
  final String email;
  final Gender gender;
  final String dob;
  final AgeAccountType ageAccountType;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.dob,
    required this.ageAccountType,
    required this.createdAt,
    required this.updatedAt,
  });

  //fromJson
  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data["id"],
        name: data["name"],
        email: data["email"],
        gender: data["gender"],
        dob: data["dob"],
        ageAccountType: data["age_account_type"],
        createdAt: data["created_at"],
        updatedAt: data["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "gender": gender,
    "dob": dob,
    "age_account_type": ageAccountType,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
