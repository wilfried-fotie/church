import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tools.dart';

class LivesVideos extends StatelessWidget {
  const LivesVideos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: kPrimaryColor,
                height: MediaQuery.of(context).size.height / 2,
              ),
              const Text(
                "Des cultes en direct !!! cette fonctionnalité n'est pas encore disponible.",
                textAlign: TextAlign.center,
                style: kPrimaryTextWhite,
              ),
              Positioned(
                top: 60,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: kBackColor)),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kBackColor),
                    child: const Text(
                        "Faites des dons au +237 ......... pour nous permettre de continuer et soutenir la réalisation et la maintenance de l'application.")),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kBackColor),
                    child: const Text(
                        "Faites des dons au +237 ......... pour nous permettre de continuer et soutenir la réalisation et la maintenance de l'application.")),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                    margin: const EdgeInsets.only(left: 50.0, right: 20),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kBackColor),
                    child: const Text("Merci")),
              ),
            ],
          )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Icon(CupertinoIcons.hand_thumbsup),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  child: TextField(
                    decoration: inputStyle.copyWith(hintText: "Commentaire"),
                  ),
                )),
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.send),
              ],
            ),
          )
        ],
      )),
    );
  }
}
