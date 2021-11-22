import 'package:flutter/material.dart';

class User {
  String name;
  String desc;
  String email;
  String imageUrl;

  User({
    @required this.name,
    @required this.desc,
    @required this.email,
    @required this.imageUrl,
  });

  //getter
  get UserName => this.name;
  get UserEmail => this.email;
  get UserDesc => this.desc;
  get UserImage => this.imageUrl;
}
