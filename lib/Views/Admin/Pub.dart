import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Services/PubService.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../Model/PubModel.dart';
import '../../Services/FileManager.dart';
import '../../tools.dart';
import '../Widgets/getImage.dart';

class PubsUi extends StatefulWidget {
  const PubsUi({Key? key}) : super(key: key);

  @override
  State<PubsUi> createState() => _PubsUiState();
}

class _PubsUiState extends State<PubsUi> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController paroisse = TextEditingController();
  late final TextEditingController berger = TextEditingController();
  late final TextEditingController endDate = TextEditingController();
  late final TextEditingController prix = TextEditingController();
  late final TextEditingController departement = TextEditingController();
  String? fileName;
  File? _fileData;
  bool loader = false, _switch = true;
  File? _image;

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
    endDate.dispose();
    scroll.dispose();
    prix.dispose();
    departement.dispose();
    berger.dispose();
  }

  void clear() {
    paroisse.clear();
    endDate.clear();
    prix.clear();
    departement.clear();
    berger.clear();
    loader = false;
    fileName = null;

    _image = null;
  }

  @override
  Widget build(BuildContext context) {
    PubService _medData = PubService();

    return SafeArea(
        child: StreamBuilder<List<PubModel>>(
            stream: PubService().getStreamPubs(nbre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PubModel>? Pubs = snapshot.data;
                return Scaffold(
                    appBar: AppBar(
                      title: const Text("Administration Pubs"),
                    ),
                    floatingActionButton: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: kSecondaryColor),
                      child: IconButton(
                        onPressed: () {
                          addParoisses(context, _medData, Pubs);
                        },
                        icon: const Icon(Icons.add, color: kPrimaryColor),
                      ),
                    ),
                    body: ListView(
                      controller: scroll,
                      children: Pubs!.map((value) {
                        PubModel data = value;
                        return Pubstructure(
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
      BuildContext context, PubService _medData, myModel) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
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
                                    "Ajouter Un Pub",
                                    style: kBoldText,
                                  ),
                                  const SizedBox(height: 20),
                                  _image != null
                                      ? SizedBox(
                                          height: 100,
                                          child: Image.file(
                                            File(_image!.path),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
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
                                                "Importer l'image du Pub",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          IconButton(
                                              onPressed: () async {
                                                try {
                                                  final result =
                                                      await showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              bc) {
                                                            return const GetImage(
                                                                rad: true);
                                                          });

                                                  setState(() {
                                                    _image = result;
                                                  });
                                                } catch (err) {
                                                  print(err);
                                                  print("err");
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.photo_camera)),
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
                                          labelText: "url du Pub"),
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
                                      decoration: inputStyle.copyWith(
                                          labelText: "Description du Pub"),
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
                                      const Text("Ce Pub est payant?"),
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
                                            controller: endDate,
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
                                  !_switch
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20.0, right: 5),
                                          child: Row(
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0),
                                                  child: Text(
                                                    "Importer le pdf du Pub",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              IconButton(
                                                  onPressed: () async {
                                                    try {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'pdf',
                                                        ],
                                                      );

                                                      if (result != null) {
                                                        File file = File(result
                                                            .files
                                                            .single
                                                            .path!);
                                                        setState(() {
                                                          fileName = result
                                                              .files.first.name;
                                                          _fileData = file;
                                                        });
                                                      } else
                                                        return;
                                                    } catch (err) {
                                                      print(err);
                                                      print("err");
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.picture_as_pdf)),
                                            ],
                                          ))
                                      : Container(),
                                  const SizedBox(height: 20),
                                  fileName != null && !_switch
                                      ? Text(fileName!)
                                      : Container(),
                                  fileName != null && !_switch
                                      ? const SizedBox(height: 20)
                                      : Container(),
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
                                                    !_switch
                                                ? _fileData != null
                                                : true) {
                                              setState(() {
                                                loader = true;
                                              });
                                              try {
                                                String? urlImage =
                                                    _image != null
                                                        ? await FileMananger
                                                            .uploadFile(
                                                                _image!.path,
                                                                "Pubs")
                                                        : null;
                                                String? urlPdf =
                                                    fileName != null
                                                        ? await FileMananger
                                                            .uploadFile(
                                                                _fileData!.path,
                                                                "Pubs")
                                                        : null;

                                                await _medData.addPub(PubModel(
                                                  url: paroisse.value.text,
                                                  image: urlImage!,
                                                  startDate: berger.value.text,
                                                  endDate: endDate.value.text,
                                                ));

                                                Navigator.of(context).pop();
                                                clear();
                                              } catch (error) {
                                                print(error);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Une erreur est survenu !!! svp verifier l'image du Pub",
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
                                            }
                                          },
                                          child: const Text(
                                            "Ajouter Le Pub",
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

class Pubstructure extends StatefulWidget {
  final PubModel data;
  const Pubstructure({Key? key, required this.data}) : super(key: key);
  @override
  State<Pubstructure> createState() => _PubstructureState();
}

class _PubstructureState extends State<Pubstructure> {
  bool _loader2 = false;

  @override
  @override
  Widget build(BuildContext context) {
    PubService _medData = PubService();

    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ModPub(data: widget.data)));
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
                                    "Voules vous vraiment tout supprimer ?"),
                            actions: _loader2
                                ? []
                                : [
                                    TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            _loader2 = true;
                                          });
                                          try {
                                            if (widget.data.image != null) {
                                              await FileMananger.delete(
                                                  widget.data.image!);
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
                                            if (mounted) {
                                              setState(() {
                                                _loader2 = false;
                                              });
                                            }

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
          title: Text(widget.data.url!),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 0),
            child: Text(widget.data.startDate),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}

class ModPub extends StatefulWidget {
  final PubModel data;
  const ModPub({Key? key, required this.data}) : super(key: key);

  @override
  State<ModPub> createState() => _ModPubstate();
}

class _ModPubstate extends State<ModPub> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController paroisse =
      TextEditingController(text: widget.data.url);

  late final TextEditingController berger =
      TextEditingController(text: widget.data.startDate);
  late final TextEditingController endDate =
      TextEditingController(text: widget.data.endDate);

  late final TextEditingController distric =
      TextEditingController(text: widget.data.url.toString());

  late final TextEditingController departement =
      TextEditingController(text: widget.data.startDate);

  bool load = false;
  late PubModel data = widget.data;
  bool _loader = false;
  bool _loader2 = false;
  String? fileName, fileNamePdf;
  PubService _medData = PubService();
  File? _image, _pdf;

  @override
  void dispose() {
    super.dispose();
    paroisse.dispose();
    distric.dispose();
    berger.dispose();
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
            "Modifier Le Pub",
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
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(height: 20),
                                _image != null
                                    ? SizedBox(
                                        height: 100,
                                        child: Image.file(
                                          File(_image!.path),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : widget.data.image != null
                                        ? CachedNetworkImage(
                                            height: 80,
                                            fit: BoxFit.cover,
                                            imageUrl: widget.data.image!,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                                    color: kPrimaryColor),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
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
                                              "Modifier l'image du Pub",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        IconButton(
                                            onPressed: () async {
                                              try {
                                                final result =
                                                    await showModalBottomSheet(
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return const GetImage(
                                                              rad: true);
                                                        });

                                                setState(() {
                                                  _image = result;
                                                });
                                              } catch (err) {
                                                print(err);
                                                print("err");
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.photo_camera)),
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
                                        labelText: "url du Pub"),
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
                                    decoration: inputStyle.copyWith(
                                        labelText: "Description du Pub"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                        labelText: "Auteur du Pub"),
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
                                    const Text("Ce Pub est payant?"),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 25,
                                          top: 20,
                                          left: 20.0,
                                          right: 20),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: endDate,
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
                                    ),
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
                                              if (key.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  load = true;
                                                });
                                                try {
                                                  print(_image);

                                                  String? urlImage =
                                                      _image != null
                                                          ? await FileMananger
                                                              .uploadFile(
                                                                  _image!.path,
                                                                  "Pubs")
                                                          : widget.data.image;

                                                  (_image != null &&
                                                          widget.data.image !=
                                                              null)
                                                      ? await FileMananger
                                                          .delete(
                                                              widget.data.image)
                                                      : null;

                                                  await _medData.updatePub(
                                                      PubModel(
                                                        url:
                                                            paroisse.value.text,
                                                        date: widget.data.date,
                                                        image: urlImage!,
                                                        startDate:
                                                            berger.value.text,
                                                        endDate:
                                                            endDate.value.text,
                                                      ),
                                                      widget.data.id!);

                                                  Navigator.of(context).pop();
                                                } catch (error) {
                                                  print(error);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Une erreur est survenu",
                                                      backgroundColor:
                                                          Colors.red,
                                                      fontSize: 18,
                                                      textColor: Colors.white);
                                                }
                                              }
                                            },
                                            child: const Text(
                                              "Modifier Le Pub",
                                              style: TextStyle(
                                                  color: kPrimaryColor),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              clear();
                                            },
                                            child: const Text(
                                              "Annuler",
                                              style:
                                                  TextStyle(color: kTextColor),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ))))
            ]));
  }
}
