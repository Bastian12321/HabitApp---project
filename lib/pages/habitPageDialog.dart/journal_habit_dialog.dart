import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

void showJournalHabitDialog(BuildContext context, HabitUI data, TextEditingController habitNameController, TextEditingController integerController, List<String> frequencyOptions, int Function(String) frequencyToInt) {
  String frequency = 'every day';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Text("New Journaling Habit"),
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
                  frequency = newValue!;
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
                decoration: InputDecoration(labelText: 'Days habit is repeated'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String habitName = habitNameController.text;
              int integerValue = int.tryParse(integerController.text) ?? 0;
              int day = frequencyToInt(frequency);

              // Validate integer value
              if (integerValue < 1 || integerValue > 365) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a value between 1 and 365')),
                );
                return;
              }

              data.habitRep(integerValue, day, habitName);
              habitNameController.clear();
              integerController.clear();
              Navigator.of(context).pop();
            },
            child: Text("Submit"),
          )
        ],
      );
    },
  );
}