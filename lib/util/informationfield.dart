import 'package:flutter/material.dart';

class Informationfield extends StatelessWidget {
  final String hint;
  bool isPassword = false;
  final TextEditingController controller;
  final String value;
  final String? Function(String?)? validator;
  
  Informationfield({
    super.key, 
    required this.hint,
    required this.controller,
    this.value = '',
    this.isPassword = false,
    this.validator,
  });
  
  @override
  TextFormField build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      style: const TextStyle(color: Colors.black),
      obscureText: isPassword,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Color.fromARGB(255, 228, 181, 176),
        contentPadding: const EdgeInsets.all(16),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 14,
        )
      ),
    );
  }
}