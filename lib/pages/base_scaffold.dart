import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Widget body;

  const BaseScaffold({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Achievements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Friends',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 210, 142, 134),
          onTap: onItemTapped,
        ),
      ),
    );
  }
}