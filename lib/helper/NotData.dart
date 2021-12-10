import 'package:flutter/material.dart';

import '../tools.dart';

Center notData(text) {
  return Center(
    child: Column(
      children: [
        LinearProgressIndicator(
          color: kPrimaryColor,
          backgroundColor: kSecondaryColor,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
