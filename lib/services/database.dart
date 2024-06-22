import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habitapp/util/habitinterface.dart';

class Database {

  final String uid;
  Database({required this.uid});

  final CollectionReference userData = FirebaseFirestore.instance.collection('collection');

  Future updateUserData(String username, String? profilePictureURL) async {
    HabitUI habitUI = HabitUI();
    return await userData.doc(uid).set({
      'username' : username,
      'profilePicture' : profilePictureURL,
      'habitdata' : habitUI.toMap(),
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

  Future<void> updateHabits(HabitUI habitUI) async {
    try {
      await userData.doc(uid).update({
        'habitdata': habitUI.toMap(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> getHabits() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('collection').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching habits: ${e.toString()}');
      return {};
    }
  }


  Future<void> addHabit(DateTime day, String title, {int? goalamount, double? goalduration}) async {
    try {
      DocumentSnapshot doc = await userData.doc(uid).get();
      HabitUI habitUI;
      if (doc.exists) {
        habitUI = HabitUI.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        habitUI = HabitUI();
      }
      habitUI.addHabit(day, title, goalamount: goalamount, goalduration: goalduration);
      await updateHabits(habitUI);
    } catch (e) {
      print(e.toString());
    }
  }
}