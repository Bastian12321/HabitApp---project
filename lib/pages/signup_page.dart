import 'package:flutter/material.dart';
import 'package:habitapp/util/informationfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitapp/util/auth.dart';

class SignupPage extends StatefulWidget {

  final Function toggleView;
  SignupPage({required this.toggleView});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {  

  String? errorMessage = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Auth _auth = Auth();

  Future<void> newUser() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        _emailController.text, 
        _passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D716F),
      appBar: AppBar(
        title: const Text(
          'TrackIT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          height: 400,
          width: 300,
          child: Form(
            
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Informationfield(
                  hint: 'email',
                  controller: _emailController,
                  validator: (s) => s!.isEmpty 
                    ? 'Please enter an email' 
                    : null,
                ),
                const SizedBox(height: 20.0), //spacing
                Informationfield(
                  hint: 'create password', 
                  isPassword: true,
                  controller: _passwordController,
                  validator: (s) => s!.length < 6 
                    ? 'Password must be at least 6 characters' 
                    : null,
                ),
                const SizedBox(height: 20.0), //spacing
                Informationfield(
                  hint: 'confirm password', 
                  isPassword: true,
                  controller: _confirmController,
                  validator: (s) => s! != _passwordController.text 
                    ? 'Passwords do not match' 
                    : null,
                ),
                const SizedBox(height: 20.0), //spacing
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        newUser();
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Text('sign up'),
                    elevation: 15,
                    color: const Color.fromARGB(255, 232, 124, 112),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), 
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: TextButton(
          child: const Text(
            'already registered',
            style: TextStyle(
              color: const Color.fromARGB(255, 232, 124, 112),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ), 
          ),
          onPressed: () => widget.toggleView(),
        ),
      ),
    );
  }
}