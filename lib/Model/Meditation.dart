import 'dart:core';

import 'package:intl/intl.dart';

class Meditation {
  final String titre, ref, body, date;

  final String? question, pray, id, refDate;

  Meditation(
      {required this.titre,
      required this.date,
      required this.ref,
      required this.body,
      this.question,
      this.id,
      this.refDate,
      this.pray});

  Meditation.fromJson(Map<String, Object?> json, String id)
      : this(
            titre: json["titre"]! as String,
            ref: json["ref"]! as String,
            body: json["body"]! as String,
            date: json["date"]! as String,
            question: json["question"] as String?,
            refDate: json["refDate"] as String?,
            pray: json["pray"] as String?,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "titre": titre,
      "date": date,
      "body": body,
      "question": question,
      "pray": pray,
      "ref": ref,
      "month": DateFormat.yMMMEd()
          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))
          .toString()
          .substring(
              DateFormat.yMMMEd()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              int.parse(date)))
                          .toString()
                          .substring(5, 7)
                          .trim()
                          .length >
                      1
                  ? 8
                  : 7,
              DateFormat.yMMMEd()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              int.parse(date)))
                          .toString()
                          .substring(5, 7)
                          .trim()
                          .length >
                      1
                  ? 11
                  : 10)
          .trim(),
      "refDate": DateFormat.yMMMEd()
          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))
          .toString()
    };
  }
}
