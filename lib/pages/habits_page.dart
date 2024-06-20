import 'package:flutter/material.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

class HabitsPage extends StatefulWidget {
  HabitUI data;
  HabitsPage({super.key, required this.data});

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
    _selectedHabits = ValueNotifier(widget.data.getHabitsForDay(widget.data.focusedDay));
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
                        widget.data.addHabit(widget.data.selectedDay!, habitName);
                        _selectedHabits.value = widget.data.getHabitsForDay(widget.data.selectedDay!);
                      });
                      print(widget.data.getHabitsForDay(widget.data.selectedDay!));
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