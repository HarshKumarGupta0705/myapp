import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:myapp/session/session_management.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _dpFile;
  String userId;
  CollectionReference ref = FirebaseFirestore.instance.collection("users");
  @override
  void initState() {
    super.initState();
    // getting user id from local session
    SessionManagement.getLoginUID().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.topCenter,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _dpFile == null
                ? NetworkImage(
                    'https://k2partnering.com/wp-content/uploads/2016/05/Person.jpg')
                : FileImage(
                    _dpFile), //FileImage  and NetworkImage is a image provider//if we want to set default image then provide link of image else we can set null

            radius: 100,
          ),
          FloatingActionButton(
            onPressed: showModel,
            child: Icon(Icons.edit),
          )
        ],
      ),
    );
  }

  void changeDp(ImageSource imgSrc) async {
    final pickedFile = await ImagePicker().getImage(source: imgSrc);

    setState(() {
      if (pickedFile != null) {
        _dpFile = File(pickedFile.path);
        storeInServer();
      } else {
        print('No Image Selected');
      }
    });
  }

  void showModel() {
    showModalBottomSheet(
        context: context,
        builder: (build) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[700],
                      size: 50,
                    ),
                    onTap: () {
                      changeDp(ImageSource.camera);
                      Navigator.pop(build);
                    }),
                InkWell(
                    child: Icon(
                      Icons.library_add_check,
                      color: Colors.grey[700],
                      size: 50,
                    ),
                    onTap: () {
                      changeDp(ImageSource.gallery);
                      Navigator.pop(build);
                    }),
              ],
            ),
          );
        });
  }

  void updateDB(String imgUrl) async {
    Map<String, dynamic> updateData = {
      'image': imgUrl,
    };
    ref.doc(userId).update(updateData).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile Updated'),
        ),
      );
    }).catchError((onError) => print(onError));
  }

  void storeInServer() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    await storage.ref('profile/$userId.png').putFile(_dpFile).then((_) async {
      ///the upload have been completed
      ///now can access the uploaded file
      ///so,to get access of the uploaded file
      ///we need to get the url of the file
      ///following the code to get the url

      String downloadURL =
          await storage.ref('profile/$userId.png').getDownloadURL();
      updateDB(downloadURL);
    }).catchError((onError) => print(onError));
  }
}
