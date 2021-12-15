import 'package:church/Model/Enseignement.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Services/EnseignementService.dart';
import '../../Services/ParoissesService.dart';
import '../../tools.dart';

class EnseignementUi extends StatefulWidget {
  const EnseignementUi({Key? key}) : super(key: key);

  @override
  State<EnseignementUi> createState() => _EnseignementUiState();
}

class _EnseignementUiState extends State<EnseignementUi> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController paroisse = TextEditingController();
  late final TextEditingController berger = TextEditingController();
  late final TextEditingController tel = TextEditingController();
  late final TextEditingController distric = TextEditingController();
  late final TextEditingController departement = TextEditingController();

  late ScrollController scroll = ScrollController();
  // ignore: constant_identifier_names
  static const int PEERPAGE = 20;
  int nbre = 20;

  @override
  void initState() {
    super.initState();
    scroll.addListener(_scrollListener);
  }

  _scrollListener() {
    if (scroll.offset >= scroll.position.maxScrollExtent &&
        !scroll.position.outOfRange) {
      setState(() {
        nbre += PEERPAGE;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    paroisse.dispose();
    tel.dispose();
    distric.dispose();
    departement.dispose();
    scroll.dispose();
    berger.dispose();
  }

  void clear() {
    paroisse.clear();
    tel.clear();
    distric.clear();
    departement.clear();
    berger.clear();
  }

  @override
  Widget build(BuildContext context) {
    EnseignementService _medData = EnseignementService();

    return SafeArea(
        child: StreamBuilder<List<EnseignementModel>>(
            stream: _medData.getStreamEnseignements(nbre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<EnseignementModel>? paroissess = snapshot.data;
                return Scaffold(
                    appBar: AppBar(
                      title: const Text("Administration Enseignements"),
                    ),
                    floatingActionButton: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: kSecondaryColor),
                      child: IconButton(
                        onPressed: () {
                          addParoisses(context, _medData, paroissess);
                        },
                        icon: const Icon(Icons.add, color: kPrimaryColor),
                      ),
                    ),
                    body: ListView(
                      controller: scroll,
                      children: paroissess!.map((value) {
                        EnseignementModel data = value;
                        return EnseignementStructure(
                          data: data,
                        );
                      }).toList(),
                    ));
              }
              return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              );
            }));
  }

  Future<dynamic> addParoisses(
      BuildContext context, EnseignementService _medData, myModel) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Form(
                        key: key,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5.0, right: 5),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                        clear();
                                      },
                                      icon: const Icon(Icons.close)),
                                ),
                              ),
                              const Text(
                                "Ajouter Un Enseignement",
                                style: kBoldText,
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: paroisse,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 caractères";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Titre de l'enseignement"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 8,
                                  controller: berger,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 Caractères";
                                  },
                                  decoration:
                                      inputStyle.copyWith(labelText: "Message"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: departement,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Rédacteur"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: distric,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 8,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Morale de l'enseignement"),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                kSecondaryColor),
                                      ),
                                      onPressed: () {
                                        if (key.currentState!.validate()) {
                                          try {
                                            _medData.addEnseignement(
                                                EnseignementModel(
                                              titre: paroisse.value.text,
                                              author: departement.value.text,
                                              body: berger.value.text,
                                              morale: distric.value.text,
                                            ));
                                            Navigator.of(context).pop();
                                            clear();
                                          } catch (error) {
                                            Fluttertoast.showToast(
                                                msg: "Une erreur est survenu",
                                                backgroundColor: Colors.red,
                                                fontSize: 18,
                                                textColor: Colors.white);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        "Ajouter l'enseignement",
                                        style: TextStyle(color: kPrimaryColor),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        clear();
                                      },
                                      child: const Text(
                                        "Annuler",
                                        style: TextStyle(color: kTextColor),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}

class EnseignementStructure extends StatefulWidget {
  final EnseignementModel data;
  const EnseignementStructure({Key? key, required this.data}) : super(key: key);

  @override
  State<EnseignementStructure> createState() => _EnseignementStructureState();
}

class _EnseignementStructureState extends State<EnseignementStructure> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController paroisse =
      TextEditingController(text: widget.data.titre);

  late final TextEditingController berger =
      TextEditingController(text: widget.data.body);

  late final TextEditingController distric =
      TextEditingController(text: widget.data.morale);

  late final TextEditingController departement =
      TextEditingController(text: widget.data.author);

  @override
  void dispose() {
    super.dispose();
    paroisse.dispose();
    distric.dispose();
    berger.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EnseignementService _medData = EnseignementService();

    return InkWell(
      onTap: () {
        updateParoisse(context, _medData, widget.data);
      },
      child: Card(
        child: ListTile(
          trailing: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                              "Voules vous vraiment tout supprimer ?"),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  try {
                                    await _medData.delete(widget.data.id!);
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: "Une erreur est survenu",
                                        backgroundColor: Colors.red,
                                        fontSize: 18,
                                        textColor: Colors.white);
                                  } finally {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text("Supprimer")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Annuler")),
                          ],
                        ));
              },
              icon: const Icon(Icons.delete)),
          title: Text(widget.data.titre),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 0),
            child: Text(widget.data.author),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Future<dynamic> updateParoisse(BuildContext context,
      EnseignementService _medData, EnseignementModel data) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Form(
                        key: key,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5.0, right: 5),
                                  child: IconButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.close)),
                                ),
                              ),
                              const Text(
                                "Modifier l'enseignement ",
                                style: kBoldText,
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: paroisse,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 caractères";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Titre de l'enseignement"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: berger,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 8,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire 3 caractères";
                                  },
                                  decoration:
                                      inputStyle.copyWith(labelText: "Message"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: distric,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 8,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                  },
                                  decoration:
                                      inputStyle.copyWith(labelText: "Morale"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: departement,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                  },
                                  decoration:
                                      inputStyle.copyWith(labelText: "Auteur"),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        if (key.currentState!.validate()) {
                                          try {
                                            _medData.updateEnseignement(
                                              EnseignementModel(
                                                  titre: paroisse.value.text,
                                                  body: berger.value.text,
                                                  date: data.date,
                                                  author:
                                                      departement.value.text,
                                                  morale: distric.value.text),
                                              widget.data.id!,
                                            );
                                            Navigator.of(context).pop();
                                          } catch (error) {
                                            Fluttertoast.showToast(
                                                msg: "Une erreur est survenu",
                                                backgroundColor: Colors.red,
                                                fontSize: 18,
                                                textColor: Colors.white);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        "Enregistrer les modifications",
                                        style: TextStyle(color: kPrimaryColor),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Annuler",
                                        style: TextStyle(color: kTextColor),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
