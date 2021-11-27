import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Musiques extends StatelessWidget {
  const Musiques({Key? key}) : super(key: key);

  _callNumber() async {
    String number = "*";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => ListTile(
                  title: Text(
                      "Damso - God au controle de l'espèce humaine  $index"),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow),
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(Icons.stop),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            _callNumber();
                          },
                          child: const Chip(
                            label: Text("Acheter la musique"),
                            avatar: Icon(CupertinoIcons.download_circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }
}
