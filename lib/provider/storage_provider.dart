import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/util/file_compress.dart';
import 'package:path/path.dart';

class StorageProvider extends BaseStorageProvider {
  final FirebaseStorage firebaseStorage;

  StorageProvider({FirebaseStorage firebaseStorage})
      : firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadFile(File file, String path) async {
    // get a reference to the path
    //File profileImageCompress = await FileCompress().profileImageCompress(file);
    String fileName = basename(file.path);
    final miliSecs = DateTime.now().millisecondsSinceEpoch;
    StorageReference reference =
        firebaseStorage.ref().child('$path/$miliSecs\_$fileName');
    String upLoadPath = await reference.getPath();
    // put file in the path
    StorageUploadTask uploadTask = reference.putFile(file);
    //await for the upload onComplete
    StorageTaskSnapshot result = await uploadTask.onComplete;
    // retrieve the download link and return it
    String url = await result.ref.getDownloadURL();
    print(url);
    return url;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
