import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../tools.dart';

class Creator extends StatelessWidget {
  const Creator({Key? key}) : super(key: key);
  Future<bool?> _makePhoneCall(String phoneNumber) async {
    // bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);

    //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);

    // return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Développeur"),
      ),
      body: Column(
        children: [
          const Spacer(),
          Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: kPrimaryColor),
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Semantics(
                      child: Image.asset(
                    "asset/img/profil-1.png",
                    height: 200,
                  )))),
          const Spacer(),
          const Center(
            child: Text(
              "Cette Application a été réalisé par Wilfried FOTIE ",
              textAlign: TextAlign.center,
            ),
          ),
          const Center(
            child: Text(
              "Contact +237 678 61 56 77 ",
              textAlign: TextAlign.center,
              style: kBoldText,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                _makePhoneCall("+237678615677");
              },
              child: const Text("M'appeler")),
          const Spacer(),
        ],
      ),
    );
  }
}
