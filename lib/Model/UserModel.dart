import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String name, photo;
  final bool isAdmin;

  const UserModel({
    required this.name,
    required this.photo,
    this.isAdmin = false,
  });

  UserModel.fromJson(Map<String, Object?> json)
      : this(
            name: json["name"]! as String,
            photo: json["photo"]! as String,
            isAdmin: json["isAdmin"]! as bool);

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "photo": photo,
      "isAdmin": isAdmin,
    };
  }
}
