import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Model/ParoissesModel.dart';
import '../../Services/ParoissesService.dart';
import '../../tools.dart';

class ParoissesUi extends StatefulWidget {
  const ParoissesUi({Key? key}) : super(key: key);

  @override
  State<ParoissesUi> createState() => _ParoissesUiState();
}

class _ParoissesUiState extends State<ParoissesUi> {
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
    berger.dispose();
    scroll.dispose();
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
    ParoissesService _medData = ParoissesService();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Administration Paroisses"),
            ),
            floatingActionButton: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: kSecondaryColor),
                child: Consumer<List<Paroisses?>>(
                  builder: (_, paroissess, __) => IconButton(
                    onPressed: () {
                      addParoisses(context, _medData, paroissess);
                    },
                    icon: const Icon(Icons.add, color: kPrimaryColor),
                  ),
                )),
            body: Consumer<List<Paroisses?>>(builder: (_, paroisses, __) {
              print(paroisses.length);
              return ListView(
                controller: scroll,
                children: paroisses.map((value) {
                  Paroisses data = value!;
                  return ParoissesModel(
                    data: data,
                  );
                }).toList(),
              );
            })));
  }

  Future<dynamic> addParoisses(
      BuildContext context, ParoissesService _medData, myModel) {
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
                                "Ajouter Une Paroisse",
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
                                      labelText: "Nom de la paroisse"),
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
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 Caractères";
                                  },
                                  decoration:
                                      inputStyle.copyWith(labelText: "Berger"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  controller: tel,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length != 9)
                                      return "Ce champ doit faire 9 Caractères";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Numéro de téléphone"),
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
                                      inputStyle.copyWith(labelText: "Distric"),
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
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Département"),
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
                                            _medData.addParoisses(Paroisses(
                                              paroisse: paroisse.value.text,
                                              tel: tel.value.text,
                                              berger: berger.value.text,
                                              distric: departement.value.text,
                                              departement: distric.value.text,
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
                                        "Ajouter la paroisse",
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

class ParoissesModel extends StatefulWidget {
  final Paroisses data;
  const ParoissesModel({Key? key, required this.data}) : super(key: key);

  @override
  State<ParoissesModel> createState() => _ParoissesModelState();
}

class _ParoissesModelState extends State<ParoissesModel> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController paroisse =
      TextEditingController(text: widget.data.paroisse);

  late final TextEditingController berger =
      TextEditingController(text: widget.data.berger);

  late final TextEditingController tel =
      TextEditingController(text: widget.data.tel);

  late final TextEditingController distric =
      TextEditingController(text: widget.data.distric);

  late final TextEditingController departement =
      TextEditingController(text: widget.data.departement);

  @override
  void dispose() {
    super.dispose();
    paroisse.dispose();
    tel.dispose();
    distric.dispose();
    berger.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ParoissesService _medData = ParoissesService();

    return InkWell(
      onTap: () {
        updateParoisse(context, _medData, widget.data);
      },
      child: Card(
        child: ListTile(
          trailing: IconButton(
              onPressed: () {
                updateParoisse(context, _medData, widget.data);
              },
              icon: const Icon(CupertinoIcons.pen)),
          title: Text("Paroisse :  " + widget.data.paroisse),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 0),
            child: Text("Berger :  " + widget.data.berger),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Future<dynamic> updateParoisse(
      BuildContext context, ParoissesService _medData, Paroisses data) {
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
                                "Modifier la méditation",
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
                                      labelText: "Nom de la paroisse"),
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
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire 3 caractères";
                                  },
                                  decoration:
                                      inputStyle.copyWith(labelText: "Berger"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  controller: tel,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ doit faire au moins 3 caractères";
                                    if (value.length != 9)
                                      return "Ce champ doit faire 9 caractères";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Numéro de téléphone"),
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
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                  },
                                  decoration:
                                      inputStyle.copyWith(labelText: "Distric"),
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
                                      labelText: "Département"),
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
                                            _medData.updateParoisses(
                                                Paroisses(
                                                    paroisse:
                                                        paroisse.value.text,
                                                    berger: berger.value.text,
                                                    tel: tel.value.text,
                                                    departement:
                                                        departement.value.text,
                                                    distric:
                                                        distric.value.text),
                                                widget.data.id!);
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
