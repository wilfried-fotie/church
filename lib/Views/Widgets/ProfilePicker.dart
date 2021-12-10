import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../tools.dart';

class ProfilPicker extends StatefulWidget {
  final bool rad;
  const ProfilPicker({Key? key, this.rad = false}) : super(key: key);

  @override
  _ProfilPickerState createState() => _ProfilPickerState();
}

class _ProfilPickerState extends State<ProfilPicker> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  _imgFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: kPrimaryColor),
            child: Column(
              children: [
                InkWell(
                  splashColor: kSecondaryColor,
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    Column(
                      children: const [
                        Text("Image ", style: kBold),
                        Text("de ", style: kBold),
                        Text("profil ", style: kBold),
                      ],
                    ),
                    const Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                  ]),
                ),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              _showPicker(context);
            },
            child: widget.rad
                ? Container(
                    height: 100,
                    child: Image.file(
                      File(_image!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Semantics(
                      label: "image picker",
                      child: Image.file(
                        File(_image!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )),
          );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Importer de la gallerie', style: kBold),
                    onTap: () {
                      _imgFromGallery();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera', style: kBold),
                  onTap: () {
                    _imgFromCamera();
                  },
                ),
              ],
            ),
          );
        });
  }
}
