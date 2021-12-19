import 'package:church/Services/FileManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Services/GroupesServeices.dart';
import '../../tools.dart';

class Groupes extends StatefulWidget {
  const Groupes({Key? key}) : super(key: key);

  @override
  State<Groupes> createState() => _GroupesState();
}

class _GroupesState extends State<Groupes> {
  bool _loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administration des Groupes"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService().getGroups(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Une Erreur c'est produite");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text("Loading"),
              );
            }
            if (snapshot.hasData) {
              var data = snapshot.data!;
              return ListView(
                  children: data.docs
                      .map((group) => ListTile(
                          title: Text(group["groupName"]),
                          trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        StatefulBuilder(builder:
                                            (context, StateSetter setState) {
                                          return AlertDialog(
                                            title: _loader
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                kPrimaryColor),
                                                  )
                                                : const Text(
                                                    "Voules vous vraiment  supprimer ?"),
                                            actions: _loader
                                                ? []
                                                : [
                                                    TextButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            _loader = true;
                                                          });
                                                          try {
                                                            await DatabaseService()
                                                                .getFutureGroups(
                                                                    group[
                                                                        "groupId"])
                                                                .then((value) =>
                                                                    value.map(
                                                                        (e) {
                                                                      print(e
                                                                          .name);
                                                                      if (e.photo !=
                                                                          null) {
                                                                        FileMananger.delete(
                                                                            e.photo!);
                                                                      }
                                                                    }));
                                                            await DatabaseService()
                                                                .deleteGroup(group[
                                                                    "groupId"]);
                                                            group["groupIcon"] !=
                                                                    null
                                                                ? FileMananger
                                                                    .delete(group[
                                                                        "groupIcon"]!)
                                                                : null;
                                                          } catch (e) {
                                                            print(e);
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Une erreur est survenu",
                                                                backgroundColor:
                                                                    Colors.red,
                                                                fontSize: 18,
                                                                textColor:
                                                                    Colors
                                                                        .white);
                                                          } finally {
                                                            if (mounted) {
                                                              setState(() {
                                                                _loader = false;
                                                              });
                                                            }

                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          }
                                                        },
                                                        child: const Text(
                                                            "Supprimer")),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        },
                                                        child: const Text(
                                                            "Annuler")),
                                                  ],
                                          );
                                        }));
                              },
                              icon: const Icon(Icons.delete_outline)

                              // IconButton(
                              //   icon: const Icon(Icons.delete),
                              //   onPressed: () {

                              //     setState(() {
                              //       _loader = true;
                              //     });
                              //
                              //   },
                              // ),
                              )))
                      .toList());
            } else {
              return const Center(
                child: Text("Aucune Donnée"),
              );
            }
          }),
    );
  }
}
