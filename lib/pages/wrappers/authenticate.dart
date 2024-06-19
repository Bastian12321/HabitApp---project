import 'package:flutter/material.dart';
import 'package:habitapp/pages/login_page.dart';
import 'package:habitapp/pages/signup_page.dart';

class Authenticate extends StatefulWidget {
  @override
  State<Authenticate> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Authenticate> {

  bool showLoginPage = true;

  void toggleView() {
    setState(() => showLoginPage = !showLoginPage);
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage 
      ? LoginPage(toggleView: toggleView) 
      : SignupPage(toggleView: toggleView);
  }
}