import 'dart:core';

enum MESSAGETYPE { text, image }

class MessageModel {
  String author, name;

  final String? message, photo, id, date, reponseUId;
  final bool type;

  MessageModel(
      {this.date,
      required this.author,
      this.type = false,
      this.message,
      this.reponseUId,
      required this.name,
      this.photo,
      this.id});

  MessageModel.fromJson(Map<String, Object?> json, String id)
      : this(
            date: json["date"] as String?,
            author: json["author"]! as String,
            message: json["message"] as String?,
            reponseUId: json["reponseUId"] as String?,
            name: json["name"]! as String,
            photo: json["photo"] as String?,
            type: json["type"]! as bool,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "message": message,
      "name": name,
      "photo": photo,
      "author": author,
      "type": type,
      "reponseUId": reponseUId,
      "date": date ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }
}
