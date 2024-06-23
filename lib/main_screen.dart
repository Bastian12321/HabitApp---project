import 'dart:async';
import 'package:flutter/material.dart';
import 'package:habitapp/pages/base_scaffold.dart';
import 'package:habitapp/pages/journal_page.dart';
import 'package:habitapp/pages/home_page.dart';
import 'package:habitapp/pages/calendar_page.dart';
import 'package:habitapp/pages/habits_page.dart';
import 'package:habitapp/pages/profile_page.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomePage(),
      CalendarPage(),
      HabitsPage(),
      const JournalPage(),
      const ProfilePage(),
    ];
    final data = Provider.of<HabitUI>(context, listen: false);
    Timer.periodic(const Duration(seconds: 60), (timer) {
      DateTime now = DateTime.now();
      if (!isSameDay(data.currentDay, now)) {
        data.updateStreak();
      }
    }
    );
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