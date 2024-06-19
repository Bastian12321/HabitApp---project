import 'package:flutter/material.dart';
import 'package:habitapp/loading.dart';
import 'package:habitapp/util/informationfield.dart';
import 'package:habitapp/util/auth.dart';

class LoginPage extends StatefulWidget {

  final Function toggleView;

  LoginPage({required this.toggleView});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String errorMessage = '';
  bool loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: const Color(0xFF1D716F),
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
          height: 300,
          width: 300,
          child:  Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Informationfield(
                  hint: 'email', 
                  controller: _emailController,
                  value: _emailController.text,
                  validator: (s) => s!.isEmpty 
                    ? 'Please enter an email' 
                    : null,
                ),
                const SizedBox(height: 20.0), //spacing
                Informationfield(
                  hint: 'password',
                  isPassword: true,
                  controller: _passwordController,
                  validator: (s) => s!.isEmpty 
                    ? 'Please enter a password' 
                    : null,
                ),
                const SizedBox(height: 20.0), //spacing
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithEmailAndPassword(
                          _emailController.text, 
                          _passwordController.text
                        );
                        if (result == null) {
                          setState(() {
                            errorMessage = 'User is not in system';
                            loading = false;
                          });
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Text('login'),
                    elevation: 15,
                    color: const Color.fromARGB(255, 232, 124, 112),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 14
                    ),
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
            'sign up',
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