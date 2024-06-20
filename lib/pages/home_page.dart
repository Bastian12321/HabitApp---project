import 'package:habitapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:habitapp/util/habit.dart';
import 'package:habitapp/util/habitinterface.dart';

class HomePage extends StatefulWidget {
  HabitUI data;
  HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  final Auth _auth = Auth();
  late final ValueNotifier<List<Habit>> _selectedHabits;
  late final ValueNotifier<DateTime> currentDay;

  @override
  void initState() {
    super.initState();
    _selectedHabits = ValueNotifier(widget.data.getHabitsForDay(widget.data.currentDay));
    currentDay = ValueNotifier(widget.data.currentDay);
  }

 @override
  void dispose() {
    _selectedHabits.dispose();
    currentDay.dispose();
    super.dispose();
  }
  
  

@override
Widget build(BuildContext context) {
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
          child: ValueListenableBuilder<List<Habit>>(
            valueListenable: _selectedHabits,
            builder: (context, value, _) {
              List<Habit> completedHabits =
                  value.where((habit) => habit.done).toList();
              List<Habit> notCompletedHabits =
                  value.where((habit) => !habit.done).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (notCompletedHabits.isNotEmpty)
                      _buildHabitSection(
                          "Not Completed Habits", notCompletedHabits, false),
                    if (completedHabits.isNotEmpty)
                      _buildHabitSection(
                          "Completed Habits", completedHabits, true),
                  ],
                ),
              );
            },
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ListView.builder(
        shrinkWrap: true,

        itemCount: habits.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                setState(() {
                  if (habits[index].done) {
                    habits[index].incomplete();
                  } else {
                    habits[index].complete();
                  }
                  _selectedHabits.value = List.from(_selectedHabits.value);
                });
              },
              title: Text(
                '${habits[index]}',
                style: TextStyle(
                  decoration: habits[index].done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: showCheckbox
                  ? Icon(
                      habits[index].done
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: habits[index].done ? Colors.green : null,
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