import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

void showDrinkWaterHabitDialog(BuildContext context, HabitUI data, TextEditingController habitNameController, TextEditingController integerController, TextEditingController goalAmountController, int water, List<int> waterOptions, List<String> frequencyOptions, int Function(String) frequencyToInt) {
  String frequency = 'every day';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Text("New Water Drinking Habit"),
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: goalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Glasses of water to drink'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              DropdownButtonFormField<int>(
                value: water,
                onChanged: (int? newValue) {
                  water = newValue!;
                },
                items: waterOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Water amount per glass in ml'),
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
              String habitName = 'Daily Water Intake';
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
              if (goalAmount == null || goalAmount < 1 || goalAmount > 50) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a goal amount between 1 and 50')),
                );
                return;
              }

              int totalWater = goalAmount * water;
              data.habitRep(integerValue, day, habitName, goalamount: goalAmount);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Total water to drink per day: $totalWater ml')),
              );

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