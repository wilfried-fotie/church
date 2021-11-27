import 'package:church/tools.dart';
import 'package:flutter/material.dart';

class CustomListitle extends StatefulWidget {
  const CustomListitle({Key? key}) : super(key: key);

  @override
  _CustomListitleState createState() => _CustomListitleState();
}

class _CustomListitleState extends State<CustomListitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor, width: .5),
                image: const DecorationImage(
                    image: AssetImage("asset/img/logo.png"))),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              const Text(
                "Texte du jour",
                style: kBoldTextPrimaryColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Publier aujourd'hui",
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          )
        ],
      ),
    );
  }
}
