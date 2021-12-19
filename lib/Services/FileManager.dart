import 'dart:io';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// ignore: library_prefixes
import 'package:path/path.dart' as Path;
// ignore: library_prefixes
import 'package:path_provider/path_provider.dart' as Path2;

class FileMananger {
  final String bucket;

  FileMananger({required this.bucket});

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static Future<String?> uploadFile(String filePath, String bucket) async {
    File file = File(filePath);
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    String ext = Path.basename(file.path).split(".")[1].toString();
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref(bucket + "/" + time + "." + ext);
      firebase_storage.UploadTask upload = ref.putFile(file);
      var end = await upload.then((p0) => p0.ref);

      return await end.getDownloadURL();
      // ignore: nullable_type_in_catch_clause
    } catch (e) {
      throw Exception("Firestore error");
    }
  }

  static Future<void> delete(String ref) async {
    await firebase_storage.FirebaseStorage.instance.refFromURL(ref).delete();
  }

  Future<String> downloadURLExample(ref) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(ref)
        .getDownloadURL();
    return downloadURL;
  }

  static Stream<bool> contains(String title) async* {
    Directory appDocDir = await Path2.getApplicationDocumentsDirectory();

    if (appDocDir.path.contains(title)) {
      yield true;
    } else {
      yield false;
    }
  }

  static Future<String> get _logcalPath async {
    final directory = await Path2.getApplicationDocumentsDirectory();
    return directory.path; // home/directory/
  }

  static Future<File> _localFile(title) async {
    final path = await _logcalPath;
    return File(path + "/" + title); // home/directory/log.txt
  }

  static Future<bool> contain(String title, ext) async {
    Directory appDocDir = await Path2.getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$title.$ext');
    if (await downloadToFile.exists()) {
      print("le fichier exist");
      return true;
    } else {
      print("le fichier n'exist");

      return false;
    }
  }

  static Future downloadFile(String ref, String title) async {
    Directory appDocDir = await Path2.getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$title');
    try {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(ref)
          .writeToFile(downloadToFile);
      return appDocDir.path + "/" + title;
    } catch (e) {
      // throw Exception("Firestore error");
    }
  }
}
