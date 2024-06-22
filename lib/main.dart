import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habitapp/pages/journal_page.dart';
import 'package:habitapp/models/appUser.dart';
import 'package:habitapp/pages/profile_page.dart';
import 'package:habitapp/pages/wrappers/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth.dart';
import 'pages/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/habits_page.dart';
import 'package:habitapp/main_screen.dart';
import 'package:habitapp/util/habitinterface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => HabitUI(),
      child: MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: Auth().appUser,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: const Color(0xFF1D716F),
          scaffoldBackgroundColor: const Color(0xFFAAAAAA),
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
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          '/main': (context) => const MainScreen(),
          '/home': (context) => HomePage(),
          '/calendar': (context) => CalendarPage(),
          '/habits': (context) => HabitsPage(data: HabitUI(),),
          '/journal': (context) => const JournalPage(),
            '/friends': (context) => const ProfilePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}