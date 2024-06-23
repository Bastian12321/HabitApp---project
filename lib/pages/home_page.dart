import 'package:flutter/material.dart';
import 'package:habitapp/services/auth.dart';
import 'package:habitapp/util/habit.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:provider/provider.dart';
import 'package:habitapp/util/step_counter.dart'; 

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Auth _auth = Auth();

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
            label: Text('Logout'),
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
            color: const Color(0xFFD28E86),
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
                  _buildHabitSection("Not Completed Habits", habits.where((habit) => !habit.done).toList()),
                  _buildHabitSection("Completed Habits", habits.where((habit) => habit.done).toList()),
                  StepCounter(),  // Include the StepCounter widget
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitSection(String title, List<Habit> habits) {
    final data = Provider.of<HabitUI>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
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
            final backgroundColor = habit.done ? Colors.green.shade100 : Colors.white;
            final textColor = habit.done ? Colors.green.shade900 : Colors.black87;
            final isStepsHabit = habit.title.toLowerCase().contains('steps');

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  habit.toString(),
                  style: TextStyle(
                    color: textColor,
                    decoration: habit.done ? TextDecoration.lineThrough : TextDecoration.none,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    habit.goalamount != null && habit.goalamount! > 0
                        ? isStepsHabit
                            ? Text(
                                '${habit.amount}/${habit.goalamount}',
                                style: TextStyle(color: textColor),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, color: textColor),
                                    onPressed: () {
                                      setState(() {
                                        habit.decreaseAmount();
                                        data.updateHabit(habit);
                                      });
                                    },
                                  ),
                                  Text(
                                    '${habit.amount}/${habit.goalamount}',
                                    style: TextStyle(color: textColor),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: textColor),
                                    onPressed: () {
                                      setState(() {
                                        habit.increaseAmount();
                                        data.updateHabit(habit);
                                      });
                                    },
                                  ),
                                ],
                              )
                        : Icon(
                            habit.done ? Icons.check_box : Icons.check_box_outline_blank,
                            color: Colors.black,
                          ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteOptionsDialog(context, habit, data, data.currentDay);
                      },
                    ),
                  ],
                ),
                onTap: habit.goalamount == null || habit.goalamount == 0
                    ? () {
                        setState(() {
                          if (habit.done) {
                            habit.incomplete();
                          } else {
                            habit.complete();
                          }
                          data.updateHabit(habit);
                        });
                      }
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  void _showDeleteOptionsDialog(BuildContext context, Habit habit, HabitUI data, DateTime day) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Habit'),
          content: Text('Do you want to delete this habit for today or all instances in the future?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete Today'),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDelete(context, habit, data, day, false);
              },
            ),
            TextButton(
              child: Text('Delete All Future Habits'),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDelete(context, habit, data, day, true);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Habit habit, HabitUI data, DateTime day, bool deleteAllFuture) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Are you sure you want to delete "${habit.title}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  if (deleteAllFuture) {
                    data.deleteAllFutureHabits(habit);
                  } else {
                    data.removeHabit(day, habit);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}