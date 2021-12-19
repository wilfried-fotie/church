import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Services/LIvresServices.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../Model/LivreModel.dart';
import '../../Services/FileManager.dart';
import '../../tools.dart';
import '../Widgets/getImage.dart';

class LivresUi extends StatefulWidget {
  const LivresUi({Key? key}) : super(key: key);

  @override
  State<LivresUi> createState() => _LivresUiState();
}

class _LivresUiState extends State<LivresUi> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController paroisse = TextEditingController();
  late final TextEditingController berger = TextEditingController();
  late final TextEditingController tel = TextEditingController();
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
    tel.dispose();
    scroll.dispose();
    prix.dispose();
    departement.dispose();
    berger.dispose();
  }

  void clear() {
    paroisse.clear();
    tel.clear();
    prix.clear();
    departement.clear();
    berger.clear();
    loader = false;
    fileName = null;

    _image = null;
  }

  @override
  Widget build(BuildContext context) {
    LivreService _medData = LivreService();

    return SafeArea(
        child: StreamBuilder<List<LivreModel>>(
            stream: LivreService().getStreamLivres(nbre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<LivreModel>? livres = snapshot.data;
                return Scaffold(
                    appBar: AppBar(
                      title: const Text("Administration Livres"),
                    ),
                    floatingActionButton: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: kSecondaryColor),
                      child: IconButton(
                        onPressed: () {
                          addParoisses(context, _medData, livres);
                        },
                        icon: const Icon(Icons.add, color: kPrimaryColor),
                      ),
                    ),
                    body: ListView(
                      controller: scroll,
                      children: livres!.map((value) {
                        LivreModel data = value;
                        return LivreStructure(
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
      BuildContext context, LivreService _medData, myModel) {
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
                    heightFactor: .9,
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
                                    "Ajouter Un Livre",
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
                                                "Importer l'image du livre",
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
                                          labelText: "Titre du Livre"),
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
                                          labelText: "Description du livre"),
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
                                      const Text("Ce Livre est payant?"),
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
                                                    "Importer le pdf du livre",
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
                                                                "Livres")
                                                        : null;
                                                String? urlPdf =
                                                    fileName != null
                                                        ? await FileMananger
                                                            .uploadFile(
                                                                _fileData!.path,
                                                                "Livres")
                                                        : null;

                                                await _medData
                                                    .addLivre(LivreModel(
                                                  titre: paroisse.value.text,
                                                  author:
                                                      departement.value.text,
                                                  image: urlImage,
                                                  body: berger.value.text,
                                                  tel: tel.value.text,
                                                  status: _switch,
                                                  prix: _switch
                                                      ? int.parse(
                                                          prix.value.text)
                                                      : 0,
                                                  pdf: !_switch
                                                      ? urlPdf! +
                                                          "." +
                                                          fileName!
                                                              .split(".")
                                                              .last
                                                      : null,
                                                ));

                                                Navigator.of(context).pop();
                                                clear();
                                              } catch (error) {
                                                print(error);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Une erreur est survenu !!! svp verifier l'image du livre",
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
                                            "Ajouter Le Livre",
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

class LivreStructure extends StatefulWidget {
  final LivreModel data;
  const LivreStructure({Key? key, required this.data}) : super(key: key);
  @override
  State<LivreStructure> createState() => _LivreStructureState();
}

class _LivreStructureState extends State<LivreStructure> {
  bool _loader2 = false;

  @override
  @override
  Widget build(BuildContext context) {
    LivreService _medData = LivreService();

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ModLivre(data: widget.data)));
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
                                            if (widget.data.image != null) {
                                              await FileMananger.delete(
                                                  widget.data.image!);
                                            }
                                            if (widget.data.pdf != null) {
                                              await FileMananger.delete(
                                                  widget.data.pdf!);
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

class ModLivre extends StatefulWidget {
  final LivreModel data;
  const ModLivre({Key? key, required this.data}) : super(key: key);

  @override
  State<ModLivre> createState() => _ModLivreState();
}

class _ModLivreState extends State<ModLivre> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController paroisse =
      TextEditingController(text: widget.data.titre);

  late final TextEditingController berger =
      TextEditingController(text: widget.data.body);
  late final TextEditingController tel =
      TextEditingController(text: widget.data.tel);

  late final TextEditingController distric =
      TextEditingController(text: widget.data.prix.toString());

  late final TextEditingController departement =
      TextEditingController(text: widget.data.author);
  late bool status = widget.data.status;
  bool load = false;
  late LivreModel data = widget.data;
  bool _loader = false;
  bool _loader2 = false;
  String? fileName, fileNamePdf;
  LivreService _medData = LivreService();
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
          "Modifier Le Livre",
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
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : Container(),
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 5),
                          child: Row(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    "Modifier l'image du livre",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                  onPressed: () async {
                                    try {
                                      final result = await showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext bc) {
                                            return const GetImage(rad: true);
                                          });

                                      setState(() {
                                        _image = result;
                                      });
                                    } catch (err) {
                                      print(err);
                                      print("err");
                                    }
                                  },
                                  icon: const Icon(Icons.photo_camera)),
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
                          decoration:
                              inputStyle.copyWith(labelText: "Titre du Livre"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              labelText: "Description du livre"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: departement,
                          validator: (value) {
                            if (value!.trim().isEmpty)
                              return "Ce champ est réquis";
                          },
                          decoration:
                              inputStyle.copyWith(labelText: "Auteur du livre"),
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
                          const Text("Ce Livre est payant?"),
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
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, right: 5),
                              child: Row(
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 25.0),
                                      child: Text(
                                        "Importer le pdf du livre",
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
                                            allowedExtensions: ['pdf', "PDF"],
                                          );

                                          if (result != null) {
                                            File file =
                                                File(result.files.single.path!);
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
                                      icon: const Icon(Icons.picture_as_pdf)),
                                ],
                              )),
                      const SizedBox(height: 20),
                      !status
                          ? (fileNamePdf != null || data.pdf != null)
                              ? Text(fileNamePdf != null
                                  ? fileNamePdf!
                                  : _pdf != null
                                      ? data.titre + ".pdf"
                                      : data.titre + ".pdf")
                              : Container()
                          : Container(),
                      fileNamePdf != null && !status
                          ? const SizedBox(height: 20)
                          : Container(),
                      const SizedBox(
                        height: 20,
                      ),
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
                                    print(_image);

                                    String? urlImage = _image != null
                                        ? await FileMananger.uploadFile(
                                            _image!.path, "Livres")
                                        : widget.data.image;

                                    String? urlPdf = _pdf != null
                                        ? await FileMananger.uploadFile(
                                            _pdf!.path, "Livres")
                                        : widget.data.pdf;

                                    (_image != null &&
                                            widget.data.image != null)
                                        ? await FileMananger.delete(
                                            widget.data.image!)
                                        : null;

                                    _pdf != null && widget.data.pdf != null
                                        ? await FileMananger.delete(
                                            widget.data.pdf!)
                                        : null;
                                    var sta = status;

                                    if (!sta &&
                                        widget.data.pdf == null &&
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
                                    await _medData.updateLivre(
                                        LivreModel(
                                            titre: paroisse.value.text,
                                            author: departement.value.text,
                                            date: widget.data.date,
                                            image: urlImage,
                                            status: sta,
                                            body: berger.value.text,
                                            tel: tel.value.text,
                                            prix: status
                                                ? int.parse(distric.value.text)
                                                : 0,
                                            pdf: sta ? null : urlPdf),
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
                                "Modifier Le Livre",
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
