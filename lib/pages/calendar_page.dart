import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

class CalendarPage extends StatefulWidget {
  HabitUI data;
  CalendarPage({super.key, required this.data});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<Habit>> _selectedHabits;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late final ValueNotifier<DateTime> currentDay;

  @override
  void initState() {
    super.initState();
    widget.data.selectedDay = widget.data.focusedDay;
    _selectedHabits = ValueNotifier(widget.data.getHabitsForDay(widget.data.selectedDay!));
    currentDay = ValueNotifier(widget.data.currentDay);
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
                List<Habit> incompleteHabits =
                  value.where((habit) => !habit.done).toList();
                List<Habit> completeHabits =
                  value.where((habit) => habit.done).toList();
                List<Habit> combinedHabits = [];
                combinedHabits.addAll(incompleteHabits);
                combinedHabits.addAll(completeHabits);

                return ListView.builder(
                  itemCount: combinedHabits.length,
                  itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        '${combinedHabits[index]}',
                        style: TextStyle(
                          decoration: combinedHabits[index].done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Icon(
                        combinedHabits[index].done
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color:
                            combinedHabits[index].done ? Colors.green : null,
                      ),
                    ),
                  );
                },
              );
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
      focusedDay: DateTime.utc(2024,6,25),
      calendarFormat: _calendarFormat,
      eventLoader: widget.data.getHabitsForDay,
      selectedDayPredicate: (day) {
        return isSameDay(widget.data.selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay){ 
        setState(() {
          widget.data.selectedDay = selectedDay;
          widget.data.focusedDay = focusedDay;
          _selectedHabits.value = widget.data.getHabitsForDay(widget.data.selectedDay!);
        });

      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        widget.data.focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          bool allCompleted = widget.data.areAllHabitsComplete(day);
          bool anyIncompleteBeforeToday = widget.data.areAnyHabitsIncomplete(day);
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