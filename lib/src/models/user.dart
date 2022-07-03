import 'package:egnimos/src/utility/enum.dart';

class User {
  final String id;
  final String name;
  final String email;
  final Gender gender;
  final String dob;
  final String uri;
  final String uriName;
  final AgeAccountType ageAccountType;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.dob,
    required this.uri,
    required this.uriName,
    required this.ageAccountType,
    required this.createdAt,
    required this.updatedAt,
  });

  //fromJson
  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data["id"],
        name: data["name"],
        email: data["email"],
        uriName: data["uri_name"],
        gender: Gender.values.firstWhere(
          (element) => element.name == data["gender"],
          orElse: () => Gender.male,
        ),
        dob: data["dob"],
        uri: data["uri"],
        ageAccountType: AgeAccountType.values.firstWhere(
          (element) => element.name == data["age_account_type"],
          orElse: () => AgeAccountType.adult,
        ),
        createdAt: data["created_at"],
        updatedAt: data["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "gender": gender.name,
        "dob": dob,
        "uri": uri,
        "uri_name": uriName,
        "age_account_type": ageAccountType.name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
