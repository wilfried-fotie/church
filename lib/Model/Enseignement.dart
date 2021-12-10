import 'dart:core';

class EnseignementModel {
  String titre, author, body;

  final String? id, morale, date;

  EnseignementModel({
    required this.titre,
    required this.author,
    required this.body,
    this.morale,
    this.date,
    this.id,
  });

  EnseignementModel.fromJson(Map<String, Object?> json, String id)
      : this(
            titre: json["titre"]! as String,
            author: json["author"]! as String,
            body: json["body"]! as String,
            morale: json["morale"] as String?,
            date: json["date"] as String?,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "titre": titre,
      "body": body,
      "morale": morale,
      "author": author,
      "date": date ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }
}
