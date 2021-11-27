import 'package:church/tools.dart';
import 'package:flutter/material.dart';

class Iiconiseur extends StatefulWidget {
  final Widget icon;
  const Iiconiseur({Key? key, required this.icon}) : super(key: key);

  @override
  _IiconiseurState createState() => _IiconiseurState();
}

class _IiconiseurState extends State<Iiconiseur> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.icon,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
