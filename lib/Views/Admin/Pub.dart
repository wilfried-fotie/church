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
  late final TextEditingController url = TextEditingController();
  late final TextEditingController name = TextEditingController();

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
    url.dispose();
    name.dispose();
  }

  void clear() {
    url.clear();
    name.clear();

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
                                    "Ajouter Une Pub ou un Évènnement",
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
                                                "Importer l'image de la Pub",
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
                                      controller: name,
                                      validator: (value) {
                                        if (value!.trim().length < 3)
                                          return "Le nom doit faire au moins trois caratères";
                                      },
                                      decoration: inputStyle.copyWith(
                                          labelText: "Nom de la pub"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: url,
                                      decoration: inputStyle.copyWith(
                                          labelText: "URL de la Pub"),
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
                                                MaterialStateProperty.all<
                                                    Color>(kSecondaryColor),
                                          ),
                                          onPressed: () async {
                                            if (key.currentState!.validate() &&
                                                _image != null) {
                                              setState(() {
                                                loader = true;
                                              });
                                              try {
                                                String? urlImage =
                                                    await FileMananger
                                                        .uploadFile(
                                                            _image!.path,
                                                            "Pubs");

                                                await _medData.addPub(PubModel(
                                                  url: url.value.text,
                                                  name: name.value.text,
                                                  image: urlImage!,
                                                ));

                                                Navigator.of(context).pop();
                                                clear();
                                              } catch (error) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Une erreur est survenu !!! svp verifier l'image de la Pub",
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
                                            } else if (!key.currentState!
                                                    .validate() &&
                                                _image != null) {
                                              setState(() {
                                                loader = true;
                                              });
                                              try {
                                                String? urlImage =
                                                    await FileMananger
                                                        .uploadFile(
                                                            _image!.path,
                                                            "Pubs");

                                                await _medData.addPub(PubModel(
                                                  url: null,
                                                  name: name.value.text,
                                                  image: urlImage!,
                                                ));

                                                Navigator.of(context).pop();
                                                clear();
                                              } catch (error) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Une erreur est survenu !!! svp verifier l'image de la Pub",
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
                                            "Ajouter La Pub",
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
                                            await FileMananger.delete(
                                                widget.data.image);

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
          title: Text(widget.data.name),
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

  late final TextEditingController url =
      TextEditingController(text: widget.data.url);

  late final TextEditingController name =
      TextEditingController(text: widget.data.name);

  bool load = false;
  late PubModel data = widget.data;
  bool _loader = false;
  bool _loader2 = false;
  String? fileName, fileNamePdf;
  PubService _medData = PubService();
  File? _image;

  @override
  void dispose() {
    super.dispose();
    url.dispose();
    name.dispose();
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
                                    : CachedNetworkImage(
                                        height: 80,
                                        fit: BoxFit.cover,
                                        imageUrl: widget.data.image,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(
                                                color: kPrimaryColor),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
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
                                    controller: name,
                                    validator: (value) {
                                      if (value!.trim().length < 3)
                                        return "Le nom doit faire au moins trois caratères";
                                    },
                                    decoration: inputStyle.copyWith(
                                        labelText: "Nom de la pub"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: url,
                                    decoration: inputStyle.copyWith(
                                        labelText: "url du Pub"),
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
                                                      .validate() &&
                                                  (url.value.text != ""
                                                      ? Uri.parse(
                                                              url.value.text)
                                                          .isAbsolute
                                                      : true)) {
                                                setState(() {
                                                  load = true;
                                                });
                                                try {
                                                  String? urlImage =
                                                      _image != null
                                                          ? await FileMananger
                                                              .uploadFile(
                                                                  _image!.path,
                                                                  "Pubs")
                                                          : widget.data.image;

                                                  (_image != null)
                                                      ? await FileMananger
                                                          .delete(
                                                              widget.data.image)
                                                      : null;

                                                  await _medData.updatePub(
                                                      PubModel(
                                                        url: url.value.text,
                                                        name: name.value.text,
                                                        date: widget.data.date,
                                                        image: urlImage!,
                                                      ),
                                                      widget.data.id!);

                                                  Navigator.of(context).pop();
                                                } catch (error) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Une erreur est survenu",
                                                      backgroundColor:
                                                          Colors.red,
                                                      fontSize: 18,
                                                      textColor: Colors.white);
                                                }
                                              } else if (_image != null &&
                                                  !key.currentState!
                                                      .validate()) {
                                                setState(() {
                                                  load = true;
                                                });
                                                try {
                                                  String? urlImage =
                                                      _image != null
                                                          ? await FileMananger
                                                              .uploadFile(
                                                                  _image!.path,
                                                                  "Pubs")
                                                          : widget.data.image;

                                                  (_image != null)
                                                      ? await FileMananger
                                                          .delete(
                                                              widget.data.image)
                                                      : null;

                                                  await _medData.updatePub(
                                                      PubModel(
                                                        url: widget.data.url,
                                                        date: widget.data.date,
                                                        name: widget.data.name,
                                                        image: urlImage!,
                                                      ),
                                                      widget.data.id!);

                                                  Navigator.of(context).pop();
                                                } catch (error) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Une erreur est survenu",
                                                      backgroundColor:
                                                          Colors.red,
                                                      fontSize: 18,
                                                      textColor: Colors.white);
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Url invalide",
                                                    backgroundColor: Colors.red,
                                                    fontSize: 18,
                                                    textColor: Colors.white);
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
                          )))),
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
            ]));
  }
}
