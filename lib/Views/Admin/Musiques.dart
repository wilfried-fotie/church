import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Services/MusiqueServices.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../Model/MusiqueModel.dart';
import '../../Services/FileManager.dart';
import '../../tools.dart';
import '../Widgets/getImage.dart';

class MusiqueUi extends StatefulWidget {
  const MusiqueUi({
    Key? key,
  }) : super(key: key);

  @override
  State<MusiqueUi> createState() => _MusiqueUiState();
}

class _MusiqueUiState extends State<MusiqueUi> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController paroisse = TextEditingController();
  late final TextEditingController tel = TextEditingController();
  late final TextEditingController prix = TextEditingController();
  late final TextEditingController departement = TextEditingController();
  String? fileName;
  bool loader = false, _switch = true;
  File? _musique;
  late ScrollController scroll = ScrollController();
  static const int PEERPAGE = 20;
  int nbre = 20;

  @override
  void initState() {
    super.initState();
    scroll.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    paroisse.dispose();
    tel.dispose();
    prix.dispose();
    departement.dispose();
    scroll.dispose();
  }

  void clear() {
    paroisse.clear();
    tel.clear();
    prix.clear();
    departement.clear();
    loader = false;
    fileName = null;
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
  Widget build(BuildContext context) {
    MusiqueServices _medData = MusiqueServices();

    return SafeArea(
        child: StreamBuilder<List<MusiqueModel>>(
            stream: MusiqueServices().getStreamMusiques(nbre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<MusiqueModel>? musiques = snapshot.data;
                return Scaffold(
                    appBar: AppBar(
                      title: const Text("Administration Musique"),
                    ),
                    floatingActionButton: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: kSecondaryColor),
                      child: IconButton(
                        onPressed: () {
                          addParoisses(context, _medData, musiques);
                        },
                        icon: const Icon(Icons.add, color: kPrimaryColor),
                      ),
                    ),
                    body: ListView(
                      controller: scroll,
                      children: musiques!.map((value) {
                        MusiqueModel data = value;
                        return Musiquetructure(
                          data: data,
                        );
                      }).toList(),
                    ));
              }
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor));
            }));
  }

  Future<dynamic> addParoisses(
      BuildContext context, MusiqueServices _medData, myModel) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return Stack(
                alignment:
                    loader ? Alignment.bottomCenter : Alignment.bottomCenter,
                children: [
                  FractionallySizedBox(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, right: 5),
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                            clear();
                                          },
                                          icon: const Icon(Icons.close)),
                                    ),
                                  ),
                                  const Text(
                                    "Ajouter Un musique",
                                    style: kBoldText,
                                  ),
                                  const SizedBox(height: 10),
                                  fileName != null
                                      ? Text("$fileName")
                                      : Container(),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, right: 5),
                                      child: Row(
                                        children: [
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 25.0),
                                              child: Text(
                                                "Importer la musique",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          IconButton(
                                              onPressed: () async {
                                                try {
                                                  FilePickerResult? result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                      'mp3',
                                                      "MP3"
                                                    ],
                                                  );

                                                  if (result != null) {
                                                    File file = File(result
                                                        .files.single.path!);
                                                    setState(() {
                                                      fileName = result
                                                          .files.first.name;
                                                      _musique = file;
                                                    });
                                                  } else
                                                    return;
                                                } catch (err) {
                                                  print(err);
                                                  print("err");
                                                }
                                              },
                                              icon: const Icon(Icons.add)),
                                        ],
                                      )),
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
                                          labelText: "Titre de la Musique"),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const SizedBox(height: 10),
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
                                          labelText: "Auteur"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      const Text("Cette musique est payante?"),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Switch(
                                          value: _switch,
                                          onChanged: (value) {
                                            setState(() {
                                              _switch = value;
                                            });
                                          }),
                                    ],
                                  ),
                                  _switch
                                      ? const SizedBox(
                                          height: 20,
                                        )
                                      : Container(),
                                  _switch
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: prix,
                                            keyboardType: TextInputType.number,
                                            validator: _switch
                                                ? (value) {
                                                    if (value!.trim().isEmpty)
                                                      return "Ce champ est réquis";
                                                  }
                                                : null,
                                            decoration: inputStyle.copyWith(
                                                labelText: "Prix"),
                                          ),
                                        )
                                      : Container(),
                                  _switch
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 25, left: 20.0, right: 20),
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: tel,
                                            keyboardType: TextInputType.number,
                                            validator: _switch
                                                ? (value) {
                                                    if (value!.length != 9)
                                                      return "Ce champ doit faire 9 chiffres ";
                                                  }
                                                : null,
                                            decoration: inputStyle.copyWith(
                                                labelText:
                                                    "Numéro de téléphone du vendeur"),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(kSecondaryColor),
                                          ),
                                          onPressed: () async {
                                            if (key.currentState!.validate() &&
                                                fileName != null) {
                                              setState(() {
                                                loader = true;
                                              });
                                              try {
                                                String? urlPdf =
                                                    fileName != null
                                                        ? await FileMananger
                                                            .uploadFile(
                                                                _musique!.path,
                                                                "Musique")
                                                        : null;

                                                await _medData
                                                    .addMusique(MusiqueModel(
                                                  titre: paroisse.value.text,
                                                  author:
                                                      departement.value.text,
                                                  tel: tel.value.text,
                                                  status: _switch,
                                                  prix: _switch
                                                      ? int.parse(
                                                          prix.value.text)
                                                      : 0,
                                                  musique: urlPdf! +
                                                      "." +
                                                      fileName!.split(".").last,
                                                ));

                                                Navigator.of(context).pop();
                                                clear();
                                              } catch (error) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Une erreur est survenu !!! svp verifier la  musique",
                                                    backgroundColor: Colors.red,
                                                    fontSize: 18,
                                                    textColor: Colors.white);
                                              } finally {
                                                if (mounted) {
                                                  setState(() {
                                                    loader = false;
                                                  });
                                                }
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Une erreur est survenu veuillez verifier la musique !!! ",
                                                  backgroundColor: Colors.red,
                                                  fontSize: 18,
                                                  textColor: Colors.white);
                                            }
                                          },
                                          child: const Text(
                                            "Ajouter Le musique",
                                            style:
                                                TextStyle(color: kPrimaryColor),
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
                  ),
                  loader
                      ? Container(
                          color: kTextColor.withOpacity(.4),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
            }));
  }
}

class Musiquetructure extends StatefulWidget {
  final MusiqueModel data;
  const Musiquetructure({Key? key, required this.data}) : super(key: key);
  @override
  State<Musiquetructure> createState() => _MusiquetructureState();
}

class _MusiquetructureState extends State<Musiquetructure> {
  bool _loader2 = false;

  @override
  @override
  Widget build(BuildContext context) {
    MusiqueServices _medData = MusiqueServices();

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Modmusique(data: widget.data)));
      },
      child: Card(
        child: ListTile(
          trailing: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return AlertDialog(
                            title: _loader2
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: kPrimaryColor),
                                  )
                                : const Text(
                                    "Voules vous vraiment  supprimer ?"),
                            actions: _loader2
                                ? []
                                : [
                                    TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            _loader2 = true;
                                          });
                                          try {
                                            if (widget.data.musique != null) {
                                              await FileMananger.delete(
                                                  widget.data.musique!);
                                            }

                                            await _medData
                                                .delete(widget.data.id!);
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                                msg: "Une erreur est survenu",
                                                backgroundColor: Colors.red,
                                                fontSize: 18,
                                                textColor: Colors.white);
                                          } finally {
                                            setState(() {
                                              _loader2 = false;
                                            });
                                            Navigator.of(context).pop(false);
                                          }
                                        },
                                        child: const Text("Supprimer")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text("Annuler")),
                                  ],
                          );
                        }));
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
}

class Modmusique extends StatefulWidget {
  final MusiqueModel data;
  const Modmusique({Key? key, required this.data}) : super(key: key);

  @override
  State<Modmusique> createState() => _ModMusiquetate();
}

class _ModMusiquetate extends State<Modmusique> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController paroisse =
      TextEditingController(text: widget.data.titre);

  late final TextEditingController tel =
      TextEditingController(text: widget.data.tel);

  late final TextEditingController distric =
      TextEditingController(text: widget.data.prix.toString());

  late final TextEditingController departement =
      TextEditingController(text: widget.data.author);
  late bool status = widget.data.status;
  bool load = false;
  late MusiqueModel data = widget.data;
  bool _loader = false;
  bool _loader2 = false;
  String? fileName, fileNamePdf;
  MusiqueServices _medData = MusiqueServices();
  File? _image, _pdf;

  @override
  void dispose() {
    super.dispose();
    paroisse.dispose();
    distric.dispose();
    departement.dispose();
  }

  void clear() {
    load = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Modifier Le musique",
          style: kBoldText,
        ),
      ),
      body: Stack(
        alignment: load ? Alignment.topCenter : Alignment.topCenter,
        children: [
          GestureDetector(
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
                    children: [
                      Text(fileNamePdf != null
                          ? fileNamePdf!
                          : _pdf != null
                              ? data.titre + ".mp3"
                              : data.titre + ".mp3"),
                      Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Row(
                                    children: [
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 25.0),
                                          child: Text(
                                            "Importer la musique",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      IconButton(
                                          onPressed: () async {
                                            try {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'mp3',
                                                  "MP3"
                                                ],
                                              );

                                              if (result != null) {
                                                File file = File(
                                                    result.files.single.path!);
                                                setState(() {
                                                  fileNamePdf =
                                                      result.files.first.name;
                                                  _pdf = file;
                                                });
                                              } else
                                                return;
                                            } catch (err) {
                                              print(err);
                                              print("err");
                                            }
                                          },
                                          icon: const Icon(Icons.add)),
                                    ],
                                  )),
                            ],
                          )),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: paroisse,
                          validator: (value) {
                            if (value!.trim().isEmpty)
                              return "Ce champ est réquis";
                            if (value.length < 3)
                              return "Ce champ doit faire au moins 3 caractères";
                          },
                          decoration: inputStyle.copyWith(
                              labelText: "Titre de la Musique"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: departement,
                          validator: (value) {
                            if (value!.trim().isEmpty)
                              return "Ce champ est réquis";
                          },
                          decoration: inputStyle.copyWith(
                              labelText: "Auteur de la Musique"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          const Text("Ce musique est payant?"),
                          const SizedBox(
                            width: 30,
                          ),
                          Switch(
                              value: status,
                              onChanged: (value) {
                                setState(() {
                                  status = value;
                                });
                              }),
                        ],
                      ),
                      status
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 25, top: 20, left: 20.0, right: 20),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: tel,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.length != 9)
                                    return "Ce champ doit faire 9 chiffres ";
                                  if (int.parse(value) == 0)
                                    return "Ce champ est réquis";
                                },
                                decoration: inputStyle.copyWith(
                                    labelText:
                                        "Numéro de téléphone du vendeur"),
                              ),
                            )
                          : Container(),
                      status
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: distric,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim().isEmpty)
                                    return "Ce champ est réquis";
                                  if (int.parse(value) == 0)
                                    return "Ce champ est réquis";
                                },
                                decoration:
                                    inputStyle.copyWith(labelText: "Prix"),
                              ),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kSecondaryColor),
                              ),
                              onPressed: () async {
                                if (key.currentState!.validate()) {
                                  setState(() {
                                    load = true;
                                  });
                                  try {
                                    String? urlPdf = _pdf != null
                                        ? await FileMananger.uploadFile(
                                            _pdf!.path, "Musique")
                                        : widget.data.musique;

                                    _pdf != null && widget.data.musique != null
                                        ? await FileMananger.delete(
                                            widget.data.musique!)
                                        : null;
                                    var sta = status;

                                    if (!sta &&
                                        widget.data.musique == null &&
                                        _pdf == null) {
                                      Fluttertoast.showToast(
                                          msg: "Importer le fichier",
                                          backgroundColor: Colors.red,
                                          fontSize: 18,
                                          textColor: Colors.white);
                                      setState(() {
                                        load = false;
                                      });
                                      return;
                                    }
                                    await _medData.updateMusique(
                                        MusiqueModel(
                                            titre: paroisse.value.text,
                                            author: departement.value.text,
                                            date: widget.data.date,
                                            status: sta,
                                            tel: tel.value.text,
                                            prix: status
                                                ? int.parse(distric.value.text)
                                                : 0,
                                            musique: sta ? null : urlPdf),
                                        widget.data.id!);

                                    Navigator.of(context).pop();
                                  } catch (error) {
                                    print(error);
                                    Fluttertoast.showToast(
                                        msg: "Une erreur est survenu",
                                        backgroundColor: Colors.red,
                                        fontSize: 18,
                                        textColor: Colors.white);
                                  }
                                }
                              },
                              child: const Text(
                                "Modifier Le musique",
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
          load
              ? Container(
                  color: kTextColor.withOpacity(.4),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
