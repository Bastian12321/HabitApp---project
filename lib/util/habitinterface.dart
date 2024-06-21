import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:habitapp/util/habit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitapp/util/habit.dart';


class HabitUI extends ChangeNotifier{
  DateTime _currentDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  DateTime get focusedDay => _focusedDay;
  DateTime get currentDay => _currentDay;
  DateTime? get selectedDay => _selectedDay;
  
  final LinkedHashMap<DateTime, List<Habit>> habits = LinkedHashMap<DateTime, List<Habit>>(
    equals: isSameDay,
    hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
  );

  set focusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  set currentDay(DateTime day) {
    _currentDay= day;
    notifyListeners();
  }

  set selectedDay(DateTime? day) {
    _selectedDay = day;
    notifyListeners();
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
    notifyListeners();
  }

   void decreaseAmount(Habit habit) {
    habit.decreaseAmount();
    notifyListeners();
  }

  void removeHabit(DateTime day, Habit habit) {
    getHabitsForDay(day).remove(habit);
    notifyListeners();
  }

  void addHabit(DateTime day, String title, {int? goalamount, double? goalduration }) {
   if (habits[day] != null) {
    habits[day]!.add(Habit(title, goalamount: goalamount));
   } else {
    habits[day] = [Habit(title,goalamount: goalamount)];
   }
   notifyListeners();
  }

  void updateHabit(Habit habit) {
    notifyListeners();
  }
}