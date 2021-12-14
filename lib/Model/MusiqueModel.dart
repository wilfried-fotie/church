import 'dart:core';

class MusiqueModel {
  final String titre, author;

  final int? prix;

  final bool status;
  final List? download;

  String? tel;

  final String? id, date, musique, localUrl;

  MusiqueModel({
    required this.titre,
    required this.author,
    this.prix,
    this.tel,
    this.date,
    this.download,
    this.musique,
    this.localUrl,
    required this.status,
    this.id,
  });

  MusiqueModel.fromJson(Map<String, Object?> json, String id)
      : this(
            titre: json["titre"]! as String,
            author: json["author"]! as String,
            prix: json["prix"] as int?,
            date: json["date"] as String?,
            musique: json["musique"] as String?,
            tel: json["tel"] as String?,
            localUrl: json["localUrl"] as String?,
            status: json["status"]! as bool,
            download: json["download"] as List?,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "titre": titre,
      "prix": prix,
      "author": author,
      "status": status,
      "tel": tel,
      "musique": musique,
      "date": date ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }
}
