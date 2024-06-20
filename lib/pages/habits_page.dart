import 'package:flutter/material.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  late final ValueNotifier<List<Habit>> _selectedHabits;
  TextEditingController _habitController = TextEditingController();
  DateTime today = DateTime.now();
  String habitName = '';
  HabitUI habitData= HabitUI();

  @override
  void initState() {
    super.initState();
    _selectedHabits = ValueNotifier(habitData.getHabitsForDay(today));
  }

  @override
  void dispose() {
    _habitController.dispose();
    _selectedHabits.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habits',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _habitController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter text',
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text("Habit Name"),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _habitController,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      habitName = _habitController.text;
                      setState(() {
                        habitData.addHabit(today, habitName);
                        _selectedHabits.value = habitData.getHabitsForDay(today);
                      });
                      print(habitData.getHabitsForDay(today));
                      Navigator.of(context).pop();
                    },
                    child: Text("Submit"),
                  )
                ],
              );
            },
          );
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}