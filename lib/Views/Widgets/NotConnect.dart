import 'package:church/ModelView/Invite.dart';
import 'package:church/Views/auth/Choice.dart';
import 'package:church/helper/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../tools.dart';
import '../Home.dart';
import 'CustomButton.dart';

class NotConnect extends StatelessWidget {
  final String title;
  const NotConnect({Key? key, this.title = "Groupes"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 2, 15),
              child: Text(title, style: kPrimaryText),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text("Veuillez-vous connecter pour utiliser cette partie"),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: CustomButton(
                title: "Quitter le mode invité",
                onClick: () async {
                  ProfilPreferences.toggleInvite();
                  context.read<Invite>().toggleStatus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
