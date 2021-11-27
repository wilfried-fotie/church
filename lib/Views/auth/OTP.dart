import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:church/ModelView/MyLogin.dart';
import 'package:church/Views/Widgets/CustomButton.dart';
import 'package:church/Views/Widgets/MyApp.dart';
import 'package:church/Views/Widgets/SmallButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tools.dart';

// ignore: non_constant_identifier_names

Container OTP(BuildContext context, BuildContext ctx) {
  return Container(
      // height: MediaQuery.of(context).size.height / 2.2,
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Center(
            child: Text(
              "Confimer votre numéro de téléphone ",
              style: kBoldTextPrimaryColor,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: inputStyle.copyWith(
              hintText: "Ecrire le code",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
              child: CustomButton(
                title: "Confirmer",
                onClick: () {},
              ),
            ),
          ),
        ],
      ));
}
