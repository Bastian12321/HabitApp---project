import 'package:flutter/material.dart';
import 'package:habitapp/main.dart';
import 'package:habitapp/models/appUser.dart';
import 'package:habitapp/pages/wrappers/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    //hver gang en user logger ind får vi et AppUser objekt fra vores stream
    //hver gang en user logger ud får vi et null objekt fra vores stream
    //Objektet opbevares i nedenstående variabel
    final appUser = Provider.of<AppUser?>(context);

    if (appUser == null) {
      return Authenticate();
    } else {
      return const MainScreen();
    }
  }
}