import 'package:flutter/material.dart';
import 'package:habit_app/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF1D716F),
        //Color.fromARGB(227, 255, 226, 223),
        scaffoldBackgroundColor: Color(0xFFAAAAAA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D494E),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color(0xFF629183),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0D494E),
          unselectedItemColor: Color.fromARGB(255, 232, 124, 112),
          selectedItemColor: Color.fromARGB(255, 210, 142, 134),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

