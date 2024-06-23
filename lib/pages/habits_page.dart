import 'package:flutter/material.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:provider/provider.dart';
import 'package:habitapp/pages/habitPageDialog.dart/custom_habit_dialog.dart';
import 'package:habitapp/pages/habitPageDialog.dart/journal_habit_dialog.dart';
import 'package:habitapp/pages/habitPageDialog.dart/run_habit_dialog.dart';
import 'package:habitapp/pages/habitPageDialog.dart/steps_habit_dialog.dart';
import 'package:habitapp/pages/habitPageDialog.dart/water_habit_dialog.dart';
class HabitsPage extends StatefulWidget {
  HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  TextEditingController _habitController = TextEditingController();
  TextEditingController _habitNameController = TextEditingController();
  TextEditingController _integerController = TextEditingController();
  TextEditingController _goalAmountController = TextEditingController();
  String habitName = '';
  String frequency = 'every day';
  int water = 100;
  bool _showGoalAmountField = false;
  final List<String> predefinedHabits = ['Run', 'Steps', 'Drink Water', 'Journal'];
  final List<String> frequencyOptions = [
    'every day',
    'every other day',
    'every 3 days',
    'every 4 days',
    'every 5 days',
    'every 6 days',
    'every 7 days'
  ];
  final List<int> waterOptions = [
    100,
    125,
    150,
    175,
    200,
    225,
    250,
    300,
    350,
    400,
    450,
    500
  ];

  int frequencyToInt(String frequency) {
    switch (frequency) {
      case 'every day':
        return 1;
      case 'every other day':
        return 2;
      case 'every 3 days':
        return 3;
      case 'every 4 days':
        return 4;
      case 'every 5 days':
        return 5;
      case 'every 6 days':
        return 6;
      case 'every 7 days':
        return 7;
      default:
        return 1;
    }
  }

  @override
  void dispose() {
    _habitController.dispose();
    _habitNameController.dispose();
    _integerController.dispose();
    _goalAmountController.dispose();
    super.dispose();
  }

  @override
 build(BuildContext context) {
    final data = Provider.of<HabitUI>(context);
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
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => showRunHabitDialog(context, data, _habitNameController, _integerController, frequencyOptions, frequencyToInt),
                  child: Text(predefinedHabits[0]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => showStepsHabitDialog(context, data, _habitNameController, _integerController, _goalAmountController, frequencyOptions, frequencyToInt),
                  child: Text(predefinedHabits[1]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => showDrinkWaterHabitDialog(context, data, _habitNameController, _integerController, _goalAmountController, water, waterOptions, frequencyOptions, frequencyToInt),
                  child: Text(predefinedHabits[2]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => showJournalHabitDialog(context, data, _habitNameController, _integerController, frequencyOptions, frequencyToInt),
                  child: Text(predefinedHabits[3]),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => showCustomHabitDialog(context, data, _habitNameController, _integerController, _goalAmountController, _showGoalAmountField, frequencyOptions, frequencyToInt),
                child: Text("Custom Habit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}