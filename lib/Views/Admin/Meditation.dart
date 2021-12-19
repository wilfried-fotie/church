import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Model/Meditation.dart';
import '../../Services/MeditationService.dart';
import '../../tools.dart';

class MeditationUi extends StatefulWidget {
  const MeditationUi({Key? key}) : super(key: key);

  @override
  State<MeditationUi> createState() => _MeditationUiState();
}

class _MeditationUiState extends State<MeditationUi> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController titre = TextEditingController();
  late final TextEditingController body = TextEditingController();
  late final TextEditingController date = TextEditingController();
  late final TextEditingController ref = TextEditingController();
  late final TextEditingController pray = TextEditingController();
  late final TextEditingController question = TextEditingController();
  bool end = false;

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
      print("out");
    } else {
      print("normal");
    }
  }

  @override
  void dispose() {
    super.dispose();
    titre.dispose();
    date.dispose();
    ref.dispose();
    scroll.dispose();
    pray.dispose();
    question.dispose();
    body.dispose();
  }

  void clear() {
    titre.clear();
    date.clear();
    ref.clear();
    pray.clear();
    question.clear();
    body.clear();
  }

  @override
  Widget build(BuildContext context) {
    MeditationService _medData = MeditationService();

    return SafeArea(
        child: StreamBuilder<List<Meditation>>(
            stream: _medData.getStreamMeditations(nbre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Meditation>? meditations = snapshot.data;
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Administration Meditation"),
                    actions: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              "Voules vous vraiment  supprimer ?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    end = true;
                                                  });

                                                  try {
                                                    await _medData.deleteAll();
                                                  } catch (e) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Une erreur est survenu",
                                                        backgroundColor:
                                                            Colors.red,
                                                        fontSize: 18,
                                                        textColor:
                                                            Colors.white);
                                                  } finally {
                                                    Navigator.of(context)
                                                        .pop(false);

                                                    setState(() {
                                                      end = false;
                                                    });
                                                  }
                                                },
                                                child: const Text("Supprimer")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text("Annuler")),
                                          ],
                                        ));
                              },
                              icon: const Icon(Icons.delete_forever)))
                    ],
                  ),
                  floatingActionButton: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kSecondaryColor),
                    child: IconButton(
                      onPressed: () {
                        addMeditation(context, _medData, meditations);
                      },
                      icon: const Icon(Icons.add, color: kPrimaryColor),
                    ),
                  ),
                  body: end
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        )
                      : ListView(controller: scroll, children: [
                          ...meditations!.map((value) {
                            Meditation data = value;
                            return MeditModel(
                              data: data,
                            );
                          }).toList(),
                        ]),
                );
              }
              return const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              );
            }));
  }

  Future<dynamic> addMeditation(
      BuildContext context, MeditationService _medData, myModel) {
    String lastDate = myModel.length == 0
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : DateTime.fromMillisecondsSinceEpoch(int.parse(myModel.last.date))
            .add(Duration(days: myModel.length))
            .millisecondsSinceEpoch
            .toString();

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        enableDrag: false,
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
                                "Ajouter une méditation",
                                style: kBoldText,
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: titre,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 caractères";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Titre de la méditation"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: ref,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ est réquis";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Référence biblique"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: 7,
                                  minLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  controller: body,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ est réquis";
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
                                  controller: question,
                                  maxLines: 7,
                                  minLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  decoration: inputStyle.copyWith(
                                      labelText: "Question"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: pray,
                                  maxLines: 7,
                                  minLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  decoration:
                                      inputStyle.copyWith(labelText: "Prière"),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                            _medData.addMeditation(Meditation(
                                                titre: titre.value.text,
                                                date: lastDate,
                                                body: body.value.text,
                                                question: question.value.text,
                                                pray: pray.value.text,
                                                ref: ref.value.text));
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
                                        "Ajouter la meditation",
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

class MeditModel extends StatefulWidget {
  final Meditation data;
  const MeditModel({Key? key, required this.data}) : super(key: key);

  @override
  State<MeditModel> createState() => _MeditModelState();
}

class _MeditModelState extends State<MeditModel> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController titre =
      TextEditingController(text: widget.data.titre);

  late final TextEditingController body =
      TextEditingController(text: widget.data.body);

  late final TextEditingController date =
      TextEditingController(text: widget.data.date);

  late final TextEditingController ref =
      TextEditingController(text: widget.data.ref);

  late final TextEditingController pray =
      TextEditingController(text: widget.data.pray);

  late final TextEditingController question =
      TextEditingController(text: widget.data.question);

  @override
  void dispose() {
    super.dispose();
    titre.dispose();
    date.dispose();
    ref.dispose();
    pray.dispose();
    question.dispose();
    body.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MeditationService _medData = MeditationService();

    return InkWell(
      onTap: () {
        updateMeditation(context, _medData, widget.data);
      },
      child: Card(
        child: ListTile(
          trailing: IconButton(
              onPressed: () {
                updateMeditation(context, _medData, widget.data);
              },
              icon: const Icon(CupertinoIcons.pen)),
          title: Text(widget.data.titre),
          contentPadding: const EdgeInsets.all(12),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(DateFormat.yMMMEd()
                .format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(widget.data.date)))
                .toString()),
          ),
        ),
      ),
    );
  }

  Future<dynamic> updateMeditation(
      BuildContext context, MeditationService _medData, Meditation data) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        enableDrag: false,
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
                                  controller: titre,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 caractères";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Titre de la méditation"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: ref,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ est réquis";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 caractères";
                                  },
                                  decoration: inputStyle.copyWith(
                                      labelText: "Référence biblique"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: 7,
                                  minLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  controller: body,
                                  validator: (value) {
                                    if (value!.trim().isEmpty)
                                      return "Ce champ doit faire au moins 3 caractères";
                                    if (value.length < 3)
                                      return "Ce champ doit faire au moins 3 caractères";
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
                                  controller: question,
                                  maxLines: 7,
                                  minLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  decoration: inputStyle.copyWith(
                                      labelText: "Question"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: pray,
                                  maxLines: 7,
                                  minLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  decoration:
                                      inputStyle.copyWith(labelText: "Prière"),
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
                                            _medData.updateMeditation(
                                                Meditation(
                                                    titre: titre.value.text,
                                                    body: body.value.text,
                                                    date: widget.data.date,
                                                    question:
                                                        question.value.text,
                                                    pray: pray.value.text,
                                                    ref: ref.value.text),
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
