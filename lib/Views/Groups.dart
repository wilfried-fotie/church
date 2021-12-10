import 'package:church/Views/Widgets/ProfilePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../Model/MessageModel.dart';
import '../ModelView/BottomNavigationOffstage.dart';
import '../Services/MessageServices.dart';
import '../tools.dart';
import 'Widgets/CustomGroupListitle.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final MessageServices _medData = MessageServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(children: [
      const SizedBox(
        height: 30,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text("Groupes", style: kPrimaryText),
      ),
      const SizedBox(
        height: 20,
      ),
      const Divider(
        thickness: .2,
        color: kPrimaryColor,
      ),
      StreamBuilder<MessageModel>(
          stream: _medData.getLastStreamMessages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              MessageModel? data = snapshot.data;
              return ListTile(
                title: const Text("EEC Cameroun"),
                onTap: () {
                  Navigator.pushNamed(context, "/messages");
                  context.read<BottomNavigationOffstage>().toggleStatus();
                },
                subtitle: Text("Wilfried :  " +
                    (data!.message!.length > 30
                        ? data.message!.substring(0, 30) + " ..."
                        : data.message!)),
                trailing: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                      DateFormat.Hm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(data.date!))),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 10)),
                ),
                // Container(
                //     height: 30,
                //     width: 30,
                //     child: Center(
                //       child: Text(
                //         "+9",
                //         style: Theme.of(context)
                //             .textTheme
                //             .subtitle1!
                //             .copyWith(fontSize: 10, color: Colors.white),
                //       ),
                //     ),
                //     decoration: const BoxDecoration(
                //         shape: BoxShape.circle, color: kPrimaryColor))

                leading: const CircleAvatar(
                  backgroundImage: AssetImage("asset/img/logo.png"),
                ),
              );
            }
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor));
          }),
      const Divider(
        thickness: .2,
        color: kPrimaryColor,
      ),
    ])));
  }
}
