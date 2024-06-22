import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

void showCustomHabitDialog(BuildContext context, HabitUI data, ValueNotifier<List<Habit>> selectedHabits, TextEditingController habitNameController, TextEditingController integerController, TextEditingController goalAmountController, bool showGoalAmountField, List<String> frequencyOptions, int Function(String) frequencyToInt) {
  String frequency = 'every day';

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            title: Text("New Custom Habit"),
            content: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    controller: habitNameController,
                    decoration: InputDecoration(labelText: 'Habit Name'),
                  ),
                  DropdownButtonFormField<String>(
                    value: frequency,
                    onChanged: (String? newValue) {
                      setState(() {
                        frequency = newValue!;
                      });
                    },
                    items: frequencyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Frequency'),
                  ),
                  TextField(
                    controller: integerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Integer up to 100'),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  if (showGoalAmountField)
                    TextField(
                      controller: goalAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Integer up to 100000'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showGoalAmountField = !showGoalAmountField;
                      });
                    },
                    child: Text(showGoalAmountField ? 'Hide Goal Amount' : 'Add Goal Amount'),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  String habitName = habitNameController.text;
                  int integerValue = int.tryParse(integerController.text) ?? 0;
                  int? goalAmount = int.tryParse(goalAmountController.text);
                  int day = frequencyToInt(frequency);

                  // Validate integer value
                  if (integerValue < 1 || integerValue > 100) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a value between 1 and 100')),
                    );
                    return;
                  }

                  if (showGoalAmountField && (goalAmount == null || goalAmount < 1 || goalAmount > 100000)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a goal amount between 1 and 100000')),
                    );
                    return;
                  }

                  data.habitRep(integerValue, day, habitName, goalamount: goalAmount);
                  selectedHabits.value = data.getHabitsForDay(data.selectedDay!);

                  habitNameController.clear();
                  integerController.clear();
                  goalAmountController.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Submit"),
              )
            ],
          );
        },
      );
    },
  );
}