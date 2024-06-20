import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {

  final String uid;
  Database({required this.uid});

  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('collection');

  Future updateUserData(String username, Image? profilePicture) async {
    return await brewCollection.doc(uid).set({
      'username' : username,
      'profilePicture' : profilePicture,
    });
  }

}