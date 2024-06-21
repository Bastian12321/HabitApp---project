import 'package:habitapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:habitapp/util/habit.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  final Auth _auth = Auth();
  late final ValueNotifier<List<Habit>> _selectedHabits;
  late final ValueNotifier<DateTime> currentDay;

 @override
  void dispose() {
    _selectedHabits.dispose();
    currentDay.dispose();
    super.dispose();
  }
  
  

@override
  Widget build(BuildContext context) {
    final data = Provider.of<HabitUI>(context);
    final habits = data.getHabitsForDay(data.currentDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 20),
            color: const Color.fromARGB(255, 210, 142, 134),
            child: const Text(
              'Habits for today',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHabitSection("Not Completed Habits", habits.where((habit) => !habit.done).toList(), false),
                  _buildHabitSection("Completed Habits", habits.where((habit) => habit.done).toList(), true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitSection(String title, List<Habit> habits, bool showCheckbox) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    if (habit.done) {
                      habit.incomplete();
                    } else {
                      habit.complete();
                    }
                    Provider.of<HabitUI>(context, listen: false).updateHabit(habit);
                  });
                },
                title: Text(
                  habit.toString(),
                  style: TextStyle(
                    decoration: habit.done ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                trailing: showCheckbox
                    ? Icon(
                        habit.done ? Icons.check_box : Icons.check_box_outline_blank,
                        color: habit.done ? Colors.green : null,
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}