import 'dart:core';

class PubModel {
  final String image, startDate, endDate;
  final String? url, id, date;

  PubModel({
    required this.image,
    required this.startDate,
    required this.endDate,
    this.url,
    this.date,
    this.id,
  });

  PubModel.fromJson(Map<String, Object?> json, String id)
      : this(
            image: json["image"]! as String,
            url: json["url"] as String?,
            endDate: json["endDate"]! as String,
            startDate: json["startDate"]! as String,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "image": image,
      "url": url,
      "endDate": endDate,
      "date": date ?? DateTime.now().millisecondsSinceEpoch.toString(),
      "startDate": startDate,
    };
  }
}
