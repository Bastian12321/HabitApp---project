import 'dart:collection';

import 'package:habitapp/util/habit.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitUI {
  DateTime _currentDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime get focusedDay => _focusedDay;
  DateTime get currentDay => _currentDay;
  DateTime? get selectedDay => _selectedDay;
  
  static final LinkedHashMap<DateTime, List<Habit>> habits = LinkedHashMap<DateTime, List<Habit>>(
    equals: isSameDay,
    hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
  );

  set focusedDay(DateTime day) {
    _focusedDay = day;
  }

  set currentDay(DateTime day) {
    _currentDay= day;
  }

  set selectedDay(DateTime? day) {
    _selectedDay = day;
  }

  List<Habit> getHabitsForDay(DateTime day) {
    return habits[day] ?? [];
  }

  bool areAllHabitsComplete(DateTime day) {
    if(day.isAfter(DateTime.now())) {
      return false;
    }
    final dayHabits = getHabitsForDay(day);
    if (dayHabits.isEmpty) return false;
    return dayHabits.every((event) => event.done);
  }

  bool areAnyHabitsIncomplete(DateTime day) {
    if(day.isAfter(DateTime.now())) {
      return false;
    }
    final dayHabits = getHabitsForDay(day);
    if (dayHabits.isEmpty) return false;
    return dayHabits.any((event) => !event.done);
  }

  void increaseAmount(Habit habit) {
    habit.increaseAmount();
  }

   void decreaseAmount(Habit habit) {
    habit.decreaseAmount();
  }

  void removeHabit(DateTime day, Habit habit) {
    getHabitsForDay(day).remove(habit);
  }

  void addHabit(DateTime day, String title, {int? goalamount, double? goalduration }) {
   if (habits[day] != null) {
    habits[day]!.add(Habit(title, goalamount: goalamount, goalduration: goalduration));
   } else {
    habits[day] = [Habit(title,goalamount: goalamount, goalduration: goalduration)];
   }
  }
}