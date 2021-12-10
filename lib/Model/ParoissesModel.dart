import 'dart:core';

import 'package:intl/intl.dart';

class Paroisses {
  final String berger, paroisse, tel, distric, departement;

  final String? id;

  Paroisses({
    required this.paroisse,
    required this.berger,
    required this.distric,
    required this.departement,
    required this.tel,
    this.id,
  });

  Paroisses.fromJson(Map<String, Object?> json, String id)
      : this(
            paroisse: json["paroisse"]! as String,
            berger: json["berger"]! as String,
            distric: json["distric"]! as String,
            departement: json["departement"]! as String,
            tel: json["tel"]! as String,
            id: id);

  Map<String, Object?> toJson() {
    return {
      "paroisse": paroisse,
      "berger": berger,
      "tel": tel,
      "distric": distric,
      "departement": departement,
    };
  }
}
