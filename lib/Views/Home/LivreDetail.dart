import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Services/FileManager.dart';
import 'package:church/Services/LIvresServices.dart';
import 'package:church/Views/Home/Livres.dart';
import 'package:church/Views/Widgets/CustomButton.dart';
import 'package:church/Views/Widgets/MyApp.dart';
import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Model/LivreModel.dart';
import '../Widgets/SmallButton.dart';

class LivreDetail extends StatefulWidget {
  final LivreModel data;
  const LivreDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<LivreDetail> createState() => _LivreDetailState();
}

class _LivreDetailState extends State<LivreDetail> {
  late LivreModel data = widget.data;

  int number = 1;
  bool _download = false;
  String? _lacal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.titre.toTitleCase),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: data.image == null
                ? null
                : MediaQuery.of(context).size.height / 2,
            child: data.image != null
                ? CachedNetworkImage(
                    height: 180,
                    fit: BoxFit.cover,
                    imageUrl: data.image!,
                    placeholder: (context, url) => const Center(
                          child:
                              CircularProgressIndicator(color: kPrimaryColor),
                        ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error))
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              data.titre,
              style: kBoldBlack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              data.body ?? "",
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Text(
                data.prix != 0
                    ? "Prix: " + (number * data.prix!).toString() + " XAF"
                    : "Gratuit",
                style: kBoldBlack,
              ),
            ]),
          ),
          data.prix != 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        "Quantité",
                        style: kBoldBlack,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            if (number > 1) {
                              number--;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kSecondaryColor,
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        number.toString(),
                        style: kBoldTextPrimaryColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            if (number < 20) {
                              number++;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kSecondaryColor,
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 20,
          ),
          data.prix != 0
              ? Container(
                  alignment: Alignment.center,
                  child: CustomButton(
                      title: "Acheter le livre",
                      onClick: () async {
                        String whatsapp =
                            "+237${data.tel.toString().replaceAll(" ", "")}";
                        String whatsappURlAndroid = "whatsapp://send?phone=" +
                            whatsapp +
                            "&text= Bonjour je veux acheter $number livres ${data.titre} ";
                        String whatappURLIos =
                            "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                        if (Platform.isIOS) {
                          // for iOS phone only
                          if (await canLaunch(whatappURLIos)) {
                            await launch(whatappURLIos, forceSafariVC: false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("whatsapp no installed")));
                          }
                        } else {
                          // android , web
                          if (await canLaunch(whatsappURlAndroid)) {
                            await launch(whatsappURlAndroid);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("whatsapp no installed")));
                          }
                        }
                      }))
              : Container(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kSecondaryColor),
                      ),
                      onPressed: () async {
                        if (!await FileMananger.contain(
                            data.titre.replaceAll(" ", ""), "pdf")) {
                          setState(() {
                            _download = true;
                          });

                          try {
                            FileMananger.downloadFile(data.pdf!,
                                    data.titre.replaceAll(" ", "") + ".pdf")
                                .then((value) {
                              setState(() {
                                _download = false;
                                _lacal = value;
                              });

                              return Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                LivreService().simpleUpdateLivre({
                                  "download": FieldValue.arrayUnion(
                                      [FirebaseAuth.instance.currentUser!.uid]),
                                  "localFile": value
                                }, data.id!);

                                return PdfLocalView(
                                    url: value, title: data.titre);
                              }));
                            }).catchError((e) => Fluttertoast.showToast(
                                    msg: "Downloaded Error",
                                    backgroundColor: kPrimaryColor,
                                    fontSize: 18,
                                    textColor: Colors.white));
                          } catch (error) {
                            setState(() {
                              _download = false;
                            });
                          }
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PdfLocalView(
                                      url: data.localFile!,
                                      title: data.titre)));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _download
                              ? const CircularProgressIndicator(
                                  color: kPrimaryColor,
                                )
                              : const Icon(Icons.menu_book,
                                  color: kPrimaryColor),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Lire le Livre",
                              style: TextStyle(color: kPrimaryColor)),
                        ],
                      ),
                    ),
                  ),
                ),
          // TextButton(
          //     child: Row(
          //       children: const [
          //         Icon(Icons.read_more, color: kPrimaryColor),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text("Lire le Livre", style: TextStyle(color: kPrimaryColor)),
          //       ],
          //     ),
          //     onPressed: () {
          //       try {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (_) =>
          //                     PdfView(url: data.pdf!, title: data.titre)));
          //       } catch (r) {
          //         Fluttertoast.showToast(
          //             msg: "Une erreur est survenu",
          //             backgroundColor: Colors.red,
          //             fontSize: 18,
          //             textColor: Colors.white);
          //       }
          //     }),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class PdfView extends StatelessWidget {
  final String url, title;
  const PdfView({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SafeArea(
            child: SfPdfViewer.network(url, canShowPaginationDialog: false)));
  }
}

class PdfLocalView extends StatelessWidget {
  final String url, title;
  const PdfLocalView({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SafeArea(
              child:
                  SfPdfViewer.file(File(url), canShowPaginationDialog: false))),
    );
  }
}
