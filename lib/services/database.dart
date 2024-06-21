import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {

  final String uid;
  Database({required this.uid});

  final CollectionReference userData = FirebaseFirestore.instance.collection('collection');

  Future updateUserData(String username, String? profilePictureURL) async {
    return await userData.doc(uid).set({
      'username' : username,
      'profilePicture' : profilePictureURL,
    });
  }

  Future updateUserName(String username) async {
    await userData.doc(uid).update({
      'username' : username,
    });
  }

  Future<String> getUsername() async {
    try {
      DocumentSnapshot doc = await userData.doc(uid).get();
      if (doc.exists) {
        return doc['username'];
      } else {
        return 'no username registered';
      }
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<bool> isUserNameAvailable(String username) async {
    try {
      dynamic result = await userData.where('username', isEqualTo: username).get();
      return result.docs.isEmpty;
    } catch (e) {
      print(e.toString);
      return false;
    }
  }
}