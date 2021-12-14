import 'dart:core';

class LivreModel {
  final String titre, author;

  final int? prix;

  final bool status;
  final List? download;

  final String? image, tel;

  final String? id, body, date, pdf, localFile;

  LivreModel({
    required this.titre,
    required this.author,
    this.prix,
    this.body,
    this.image,
    this.tel,
    this.date,
    this.pdf,
    this.download,
    this.localFile,
    required this.status,
    this.id,
  });

  LivreModel.fromJson(Map<String, Object?> json, String id)
      : this(
            titre: json["titre"]! as String,
            author: json["author"]! as String,
            body: json["body"] as String?,
            prix: json["prix"] as int?,
            image: json["image"] as String?,
            date: json["date"] as String?,
            pdf: json["pdf"] as String?,
            tel: json["tel"] as String?,
            download: json["download"] as List?,
            localFile: json["localFile"] as String?,
            status: json["status"]! as bool,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "titre": titre,
      "body": body,
      "prix": prix,
      "author": author,
      "status": status,
      "image": image,
      "tel": tel,
      "pdf": pdf,
      "date": date ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }
}
