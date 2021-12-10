import 'dart:core';

enum MESSAGETYPE { text, image }

class MessageModel {
  String author;

  final String? message, photo, id, date;
  final bool type;

  MessageModel(
      {this.date,
      required this.author,
      this.type = true,
      this.message,
      this.photo,
      this.id});

  MessageModel.fromJson(Map<String, Object?> json, String id)
      : this(
            date: json["date"] as String?,
            author: json["author"]! as String,
            message: json["message"] as String?,
            photo: json["photo"] as String?,
            type: json["type"]! as bool,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "message": message,
      "photo": photo,
      "author": author,
      "type": type,
      "date": date ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }
}
