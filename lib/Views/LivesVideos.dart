import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../tools.dart';

class LivesVideos extends StatelessWidget {
  const LivesVideos({Key? key}) : super(key: key);

  Future<bool?> _makePhoneCall(String phoneNumber) async {
    // bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);

    //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);

    // return res;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: kPrimaryColor,
                height: MediaQuery.of(context).size.height / 2,
              ),
              Image.asset(
                "asset/img/pasteur.jpeg",
                filterQuality: FilterQuality.medium,
              ),
              const Text(
                "Des cultes en direct !!!",
                textAlign: TextAlign.center,
                style: kPrimaryTextWhite,
              ),
              Positioned(
                top: 100,
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
          // Expanded(
          //     child: ListView(
          //   shrinkWrap: true,
          //   physics: const ClampingScrollPhysics(),
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Container(
          //           padding: const EdgeInsets.all(10.0),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               color: kBackColor),
          //           child: const Text(
          //               "Faites des dons au +237 ......... pour nous permettre de continuer et soutenir la réalisation et la maintenance de l'application.")),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Container(
          //           padding: const EdgeInsets.all(10.0),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               color: kBackColor),
          //           child: const Text(
          //               "Faites des dons au +237 ......... pour nous permettre de continuer et soutenir la réalisation et la maintenance de l'application.")),
          //     ),
          //     Container(
          //       alignment: Alignment.centerRight,
          //       child: Container(
          //           margin: const EdgeInsets.only(left: 50.0, right: 20),
          //           padding: const EdgeInsets.all(10.0),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               color: kBackColor),
          //           child: const Text("Merci")),
          //     ),
          //   ],
          // )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // const Icon(CupertinoIcons.hand_thumbsup),
                // const SizedBox(
                //   width: 20,
                // ),
                // Expanded(
                //     child: Container(
                //   child: TextField(
                //     decoration: inputStyle.copyWith(hintText: "Commentaire"),
                //   ),
                // )),
                // const SizedBox(
                //   width: 20,
                // ),
                // const Icon(Icons.send),

                const Text(
                  "Cette fonctionnalité n'est pas encore disponible.",
                  style: kPrimaryTextSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Aidez nous à realiser ce projet!",
                    style: kPrimaryTextSmall),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: const Center(
                                child: Text("Merci Pour Votre Contribution")),
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Text(
                                          "1 -Tapez deux fois sur notre numéro de téléphone pour le selectionner et le copier. \n \n 2 - Selectionner Orange money ou MTN money \n \n 3 - au niveau du numéro de téléphone maintenez le champs jusqu'à voir apparaître coller et cliquer dessus \n \n \t Merci"),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SelectableText("677660862"),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SelectableText("678615677"),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text("Faire le don par :"),
                                    TextButton(
                                        onPressed: () async {
                                          await _makePhoneCall("#150#");
                                        },
                                        child: const Text("Orange Money")),
                                    TextButton(
                                        onPressed: () async {
                                          await _makePhoneCall("*126#");
                                        },
                                        child: const Text("MTN Mobile Money")),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                  },
                  child: Center(
                    child: Container(
                      width: 130,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: const [
                          Text(
                            "Faire un don",
                            style: kBoldWhite,
                          ),
                          Icon(CupertinoIcons.heart, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ),
                // Center(
                //   child: Container(
                //     width: 180,
                //     alignment: Alignment.center,
                //     padding: const EdgeInsets.all(10),
                //     margin: const EdgeInsets.only(top: 20),
                //     decoration: BoxDecoration(
                //         color: kPrimaryColor,
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Row(
                //       children: const [
                //         Text(
                //           "Donner votre quêtte",
                //           style: kBoldWhite,
                //         ),
                //         Icon(CupertinoIcons.heart, color: Colors.white)
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          )
        ],
      )),
    );
  }
}
