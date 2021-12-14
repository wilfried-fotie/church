class UserModel {
  final String name;
  final String? id, photo;

  const UserModel({required this.name, this.photo, this.id});

  UserModel.fromJson(Map<String, Object?> json, String id)
      : this(
            name: json["name"]! as String,
            photo: json["photo"] as String?,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "photo": photo,
    };
  }
}
