class UserModel {
  final String name, photo;
  final String? id;

  const UserModel({required this.name, required this.photo, this.id});

  UserModel.fromJson(Map<String, Object?> json, String id)
      : this(
          name: json["name"]! as String,
          photo: json["photo"]! as String,
        );

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "photo": photo,
    };
  }
}
