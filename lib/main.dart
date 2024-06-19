import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habitapp/pages/calendar_page.dart';
import 'package:habitapp/util/auth.dart';
import 'package:habitapp/models/appUser.dart';
import 'package:habitapp/pages/wrappers/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:habitapp/pages/base_scaffold.dart';
import 'package:habitapp/pages/achievements_page.dart';
import 'package:habitapp/pages/habits_page.dart';
import 'package:habitapp/pages/friends_page.dart';
import 'package:habitapp/pages/home_page.dart';
import 'package:habitapp/util/habitinterface.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: Auth().appUser,
      child: MaterialApp(
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
        home: const Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CalendarPage(),
    HabitsPage(),
    AchievementsPage(),
    FriendsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      body: _pages.elementAt(_selectedIndex),
    );
  }
}

