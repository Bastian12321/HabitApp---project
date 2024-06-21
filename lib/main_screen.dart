import 'package:flutter/material.dart';
import 'package:habitapp/pages/base_scaffold.dart';
import 'package:habitapp/pages/journal_page.dart';
import 'package:habitapp/pages/home_page.dart';
import 'package:habitapp/pages/calendar_page.dart';
import 'package:habitapp/pages/habits_page.dart';
import 'package:habitapp/pages/friends_page.dart';
import 'package:habitapp/util/habitinterface.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Initialize HabitUI
  final HabitUI habitUI = HabitUI();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const HomePage(),
      CalendarPage(data: habitUI),
      HabitsPage(data: habitUI),
      const JournalPage(),
      const FriendsPage(),
    ];
  }

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
      pages: _pages,
    );
  }
}