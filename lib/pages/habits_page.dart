import 'package:flutter/material.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';
import 'package:provider/provider.dart';

class HabitsPage extends StatefulWidget {
  HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  late final ValueNotifier<List<Habit>> _selectedHabits;
  TextEditingController _habitController = TextEditingController();
  String habitName = '';

  @override
  void initState() {
    super.initState();
    final data = Provider.of<HabitUI>(context, listen: false);
  }

  @override
  void dispose() {
    _habitController.dispose();
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
                      final data = Provider.of<HabitUI>(context, listen: false);
                      habitName = _habitController.text;
                      data.addHabit(data.selectedDay!, habitName);
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