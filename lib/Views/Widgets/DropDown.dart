import 'package:flutter/material.dart';

import '../../tools.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({Key? key}) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? value = "Aucune";

  @override
  Widget build(BuildContext context) {
    final List<String> options = ["Aucune", "Modérateur", "Pasteur"];
    final List<DropdownMenuItem<String>> _dropDown = options
        .map((String value) =>
            DropdownMenuItem(child: Text(value), value: value))
        .toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: kTextColor, width: 1.0),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton(
              elevation: 0,
              isExpanded: true,
              style: kBold,
              underline: Container(
                height: 3,
                color: Colors.transparent,
              ),
              items: _dropDown,
              value: value,
              onChanged: (String? newValue) {
                setState(() {
                  value = newValue!;
                });
              }),
        ),
      ],
    );
  }
}
