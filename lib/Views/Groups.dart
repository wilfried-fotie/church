import 'package:flutter/material.dart';
import '../tools.dart';
import 'Widgets/CustomGroupListitle.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text("Groupes", style: kPrimaryText),
        ),
        const SizedBox(
          height: 20,
        ),
        const CustomGroupListitle(
          title: "Eglise de Bandjoun Centre ",
          image: "asset/img/eglise1.png",
        ),
        const SizedBox(
          height: 20,
        ),
        const CustomGroupListitle(
          title: "Eglise de yom Bandjoun",
          image: "asset/img/eglise2.png",
        ),
        const SizedBox(
          height: 20,
        ),
        const CustomGroupListitle(
          title: "Eglise de Sacta Bandjoun",
          image: "asset/img/eglise2.png",
        )
      ],
    )));
  }
}
