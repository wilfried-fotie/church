class AdminModel {
  final String password;

  const AdminModel({
    required this.password,
  });

  AdminModel.fromJson(Map<String, Object?> json)
      : this(
          password: json["password"]! as String,
        );

  Map<String, Object?> toJson() {
    return {
      "password": password,
    };
  }
}
