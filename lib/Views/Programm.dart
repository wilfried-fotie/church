import 'package:flutter/material.dart';

import '../tools.dart';
import 'Widgets/CustomProgramListitle.dart';

class Programm extends StatelessWidget {
  const Programm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      const SizedBox(
        height: 30,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Text("Programmes", style: kPrimaryText),
      ),
      SizedBox(
        height: 20,
      ),
      CustomProgramListitle(
        getProgram: GetProgram(),
        image: "asset/img/eglise1.png",
        title: "Eglise de Bandjoun centre",
        icon: true,
      ),
      SizedBox(
        height: 20,
      ),
      CustomProgramListitle(
        getProgram: GetProgram(),
        image: "asset/img/eglise2.png",
        title: "Eglise de Bafoussam",
        icon: true,
      ),
      SizedBox(
        height: 20,
      ),
      CustomProgramListitle(
        getProgram: GetProgram(),
        image: "asset/img/eglise1.png",
        title: "Eglise de Yom Bandjoun",
        icon: true,
      ),
    ]));
  }
}

class GetProgram extends StatelessWidget {
  const GetProgram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProgramListitle(
          getProgram: Column(
            children: const [
              ListTile(
                title: Text("Messe de  06 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Messe de 09 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Messe de 15 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Action de graçe 00 h 00"),
                leading: Icon(Icons.alarm),
              ),
            ],
          ),
          title: "Lundi",
        ),
        CustomProgramListitle(
          getProgram: Column(
            children: const [
              ListTile(
                title: Text("Messe de  06 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Messe de 09 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Messe de 15 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Action de graçe 00 h 00"),
                leading: Icon(Icons.alarm),
              ),
            ],
          ),
          title: "Mardi",
        ),
        CustomProgramListitle(
          getProgram: Column(
            children: const [
              ListTile(
                title: Text("Messe de  06 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Messe de 09 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Messe de 15 h 00"),
                leading: Icon(Icons.alarm),
              ),
              ListTile(
                title: Text("Action de graçe 00 h 00"),
                leading: Icon(Icons.alarm),
              ),
            ],
          ),
          title: "Mercredi",
        )
      ],
    );
  }
}
