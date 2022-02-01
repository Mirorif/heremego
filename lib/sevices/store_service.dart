import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

class StoreService {
  static const folder = "images";

  static Future<String?> uploadImage(File _image) async {
    String? img_name = "image_" + DateTime.now().toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(folder).child(img_name + ".jpg");
    firebase_storage.UploadTask uploadTask = ref.putFile(_image);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    if(taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL() ;
      print(downloadUrl);
      return downloadUrl;
    }
   return null;
  }
}