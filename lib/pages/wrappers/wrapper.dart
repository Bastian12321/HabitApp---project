import 'package:flutter/material.dart';
import 'package:habitapp/models/appUser.dart';
import 'package:habitapp/pages/wrappers/authenticate.dart';
import 'package:habitapp/services/database.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:provider/provider.dart';
import 'package:habitapp/main_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    //hver gang en user logger ind får vi et AppUser objekt fra vores stream
    //hver gang en user logger ud får vi et null objekt fra vores stream
    //Objektet opbevares i nedenstående variabel
    final user = Provider.of<AppUser?>(context);
    
    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder<Map<String, dynamic>>(
        future: Database(uid: user.uid).getHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching habits: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            try {
              HabitUI habitUI = Provider.of<HabitUI>(context, listen: false);
              habitUI.updateFrom(HabitUI.fromMap(snapshot.data!['habitdata']));
              habitUI.user(user);
              if (snapshot.data!.containsKey('currentDay')) {
                habitUI.currentDay = DateTime.parse(snapshot.data!['currentDay']);
              }
              if (snapshot.data!.containsKey('topstreak')) {
                habitUI.currentstreak = snapshot.data!['currentstreak'];
                habitUI.streak = snapshot.data!['topstreak'];
              }
              return MainScreen();
            } catch (e) {
              return Center(child: Text('Error updating habits: $e'));
            }
          } else {
            return Center(child: Text('No data available'));
          }
        },
      );
    }
  }
}