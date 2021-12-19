import 'dart:core';

class PubModel {
  final String image, name;
  final String? url, id, date;

  PubModel({
    required this.image,
    required this.name,
    this.url,
    this.date,
    this.id,
  });

  PubModel.fromJson(Map<String, Object?> json, String id)
      : this(
            image: json["image"]! as String,
            name: json["name"]! as String,
            url: json["url"] as String?,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "image": image,
      "name": name,
      "url": url,
      "date": date ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }
}
