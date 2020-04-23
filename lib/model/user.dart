import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';

import 'package:flutter_clb_tinhban_ui_app/model/story.dart';

class User {
  final String documentId;
  final String username;
  final num age;
  final int id;
  final String name;
  final String photoUrl;
  final num phoneNumber;
  final String sex;
  final String dateOfBirth;
  final String photoCoverUrl;
  final String introductory;
  final String location;
  final List<Story> stories;

  const User({
    this.documentId,
    this.username,
    this.age,
    this.id,
    this.name,
    this.photoUrl,
    this.phoneNumber,
    this.sex,
    this.dateOfBirth,
    this.stories,
    this.photoCoverUrl,
    this.introductory,
    this.location,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["documentId"] = documentId;
    map["username"] = username;
    map["name"] = name;
    map["age"] = age;
    map["id"] = id;
    map["photoUrl"] = photoUrl;
    map["phoneNumber"] = phoneNumber;
    map["sex"] = sex;
    map["dateOfBirth"] = dateOfBirth;
    map["photoCoverUrl"] = photoCoverUrl;
    map["introductory"] = introductory;
    map["location"] = location;

    return map;
  }

  factory User.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      documentId: doc.documentID,
      name: data['name'],
      username: data['username'],
      age: data['age'],
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      sex: data['sex'],
      dateOfBirth: data['dateOfBirth'],
      photoCoverUrl: data['photoCoverUrl'],
      introductory: data['introductory'],
      location: data['location'],
    );
  }

  factory User.fromMap(Map data) {
    return User(
      documentId: data['uid'],
      name: data['name'],
      username: data['username'],
      age: data['age'],
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      sex: data['sex'],
      dateOfBirth: data['dateOfBirth'],
      photoCoverUrl: data['photoCoverUrl'],
      introductory: data['introductory'],
      location: data['location'],
    );
  }

  @override
  String toString() {
    return 'User{documentId: $documentId, username: $username, age: $age, id: $id, name: $name, photoUrl: $photoUrl, phoneNumber: $phoneNumber, sex: $sex, dateOfBirth: $dateOfBirth, photoCoverUrl: $photoCoverUrl, introductory: $introductory, location: $location, stories: $stories}';
  }
}
