import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

void showStepsHabitDialog(BuildContext context, HabitUI data, TextEditingController habitNameController, TextEditingController integerController, TextEditingController goalAmountController, List<String> frequencyOptions, int Function(String) frequencyToInt) {
  String frequency = 'every day';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Text("New Step Habit"),
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: goalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number of steps to complete'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextField(
                controller: integerController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Days habit is repeated'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String habitName = 'Daily Steps';
              int integerValue = int.tryParse(integerController.text) ?? 0;
              int day = frequencyToInt(frequency);
              int? goalAmount = int.tryParse(goalAmountController.text);

              // Validate integer value
              if (integerValue < 1 || integerValue > 365) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a value between 1 and 365')),
                );
                return;
              }
              if (goalAmount == null || goalAmount < 1 || goalAmount > 100000) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a goal amount between 1 and 100000')),
                );
                return;
              }

              data.habitRep(integerValue, day, habitName, goalamount: goalAmount);

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
}