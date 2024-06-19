import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<Habit>> _selectedHabits;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  HabitUI habitData = HabitUI();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedHabits = ValueNotifier(habitData.getHabitsForDay(_selectedDay!));
  }

 @override
  void dispose() {
    _selectedHabits.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          calendar(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _selectedHabits,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length, 
                  itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12, 
                      vertical: 4
                      ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                            value[index].done;
                            _selectedHabits.value = List.from(_selectedHabits.value);
                          });
                      },
                      title: Text(
                        '${value[index]}',
                        style: TextStyle(
                            decoration: value[index].done ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      trailing: Icon(
                          value[index].done ? Icons.check_box : Icons.check_box_outline_blank,
                          color: value[index].done ? Colors.green : null,
                        ),
                  )
                );
                });
              }),
          )
        ],
        )
    );
  }

  Widget calendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      eventLoader: habitData.getHabitsForDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay){ 
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _selectedHabits.value = habitData.getHabitsForDay(_selectedDay!);
        });

      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          bool allCompleted = habitData.areAllHabitsComplete(day);
          bool anyIncompleteBeforeToday = habitData.areAnyHabitsIncomplete(day);
          Color? bgColor;
          if (allCompleted) {
            bgColor = Colors.green;
          } else if (anyIncompleteBeforeToday) {
            bgColor = Colors.red;
          }
          return Container(
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(color: bgColor != null ? Colors.white : null),
              ),
            ),
          );
        },
    )
    
    );
  }
}