import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heremego/models/post_model.dart';
import 'package:heremego/sevices/prefs_service.dart';
import 'package:heremego/sevices/rtdb_sevice.dart';
import 'package:heremego/sevices/store_service.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  static const String id = "detail_page";

  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  File? _image;
  final picker = ImagePicker();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  _addPost() async {
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    if (title.isEmpty || content.isEmpty) return;
    if(_image == null) return;

    _apiUploadImage(title, content);
    print(title);
  }
  
  _apiUploadImage(String title, String content){
    StoreService.uploadImage(_image!).then((value) => {
      print(value),
      _apiAddPosts(title, content, value!),
    });
  }

  _apiAddPosts(String title, String content, String img_url) async {
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(content: content, title: title, userId: id, imgUrl: img_url))
        .then((value) {
      _respAddPost();
      print(value);
    });
  }

  _respAddPost() {
    Navigator.of(context).pop({"data": 'done'});
  }

  Future _getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No image selected");
        }
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Post"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  height: 100,
                  width: 100,
                  child: _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : const Image(
                          image: AssetImage("assets/images/logo.png")),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: "Content",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 45,
                color: Colors.blue,
                child: TextButton(
                  onPressed: _addPost,
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
