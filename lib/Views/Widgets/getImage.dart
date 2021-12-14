import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../tools.dart';

class GetImage extends StatefulWidget {
  final bool rad;
  const GetImage({Key? key, this.rad = false}) : super(key: key);

  @override
  _GetImageState createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Importer de la gallerie', style: kBold),
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: widget.rad ? 30 : 10);
                Navigator.of(context)
                    .pop(image != null ? File(image.path) : null);
              }),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Camera', style: kBold),
            onTap: () async {
              final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: widget.rad ? 20 : 10);

              image != null
                  ? Navigator.of(context).pop(File(image.path))
                  : Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
