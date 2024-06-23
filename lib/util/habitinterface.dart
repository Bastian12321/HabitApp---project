import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:habitapp/models/appUser.dart';
import 'package:habitapp/services/database.dart';
import 'package:habitapp/util/habit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitapp/util/pedometer.dart';


class HabitUI extends ChangeNotifier{
  AppUser? _user;
  Database? db;
  Pedometer? steps;
  DateTime _currentDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  int streak = 0;
  int currentstreak = 0;
  int currentstepforDay = 0;

  DateTime get focusedDay => _focusedDay;
  DateTime get currentDay => _currentDay;
  DateTime? get selectedDay => _selectedDay;
  
  final LinkedHashMap<DateTime, List<Habit>> habits = LinkedHashMap<DateTime, List<Habit>>(
    equals: isSameDay,
    hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
  );

  void user(AppUser login) {
    _user = login;
    db = Database(uid: login.uid);
    steps = Pedometer(onStateChange: updateStepCounter);
    steps!.realStepsCounter = currentstepforDay;
    startStepCounterToday();
  }

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
    db!.updateHabits(this);
    notifyListeners();
  }

   void decreaseAmount(Habit habit) {
    habit.decreaseAmount();
    db!.updateHabits(this);
    notifyListeners();
  }

  void removeHabit(DateTime day, Habit habit) {
    getHabitsForDay(day).remove(habit);
    db!.updateHabits(this);
    notifyListeners();
  }

  void addHabit(DateTime day, String title, {int goalamount = 0, bool stepcounter = false}) {
    if (habits[day] != null) {
      habits[day]!.add(Habit(title, goalamount: goalamount, stephabit: stepcounter));
    } else {
      habits[day] = [Habit(title, goalamount: goalamount, stephabit: stepcounter)];
    }
    db!.updateHabits(this);
    notifyListeners();
  }

  void updateHabit(Habit habit) {
    db!.updateHabits(this);
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toBeStored = {};
    habits.forEach((day, habitList) {
      List<Map<String, dynamic>> convertedHabits =
          habitList.map((habit) => habit.toMap()).toList();
      toBeStored[day.toIso8601String()] = convertedHabits;
    });
    return {
        'habitlist': toBeStored,
        'currentday': _currentDay.toIso8601String(),
        'topstreak':streak,
        'currentstreak':currentstreak,
        'currentsteps': currentstepforDay};
  }

  static HabitUI fromMap(Map<String, dynamic> map) {
  HabitUI habitUI = HabitUI();
  habitUI.currentDay = DateTime.parse(map['currentday']);
  habitUI.streak = map['topstreak'];
  habitUI.currentstreak = map['currentstreak'];
  habitUI.currentstepforDay = map['currentsteps'];
  if (map['habitlist'] != null) {
    Map<String, dynamic> habitsMap = map['habitlist'];
    habitsMap.forEach((dayString, habitList) {
      try {
        DateTime day = DateTime.parse(dayString);
        List<Habit> habits =
            (habitList as List<dynamic>).map((habitData) => Habit.fromMap(habitData)).toList();
        habitUI.habits[day] = habits;
      } catch (e) {
        print('Error parsing habits for $dayString: $e');
      }
    });
  }
    return habitUI;
  }

  void updateStreak() {
    DateTime check = _currentDay;
    if(!isSameDay(check, DateTime.now())) {
      if(areAllHabitsComplete(check)) {
        currentstreak++;
        if (currentstreak > streak) {
          streak = currentstreak;
        }
        if(!isSameDay(check.add(const Duration(days: 1)), DateTime.now())) {
          currentstreak = 0;
        }
      } else {
        currentstreak = 0;
      }
    }
    currentstepforDay = 0;
    steps!.realStepsCounter = 0;
    _currentDay = DateTime.now();
    db!.updateHabits(this);
    notifyListeners();
  }

  void updateFrom(HabitUI other) {
    _currentDay = other._currentDay;
    _focusedDay = other._focusedDay;
    _selectedDay = other._selectedDay;
    streak = other.streak;
    currentstreak = other.currentstreak;
    currentstepforDay = other.currentstepforDay;

    habits.clear();
    other.habits.forEach((day, habitList) {
      habits[day] = List<Habit>.from(habitList.map((habit) => habit.clone()));
    });
    notifyListeners();
  }

  void habitRep(int totalReps, int day, String title, {int goalamount = 0}) {
    DateTime now = DateTime.now();
    for(var i = 1; i <= totalReps; i++) {
      addHabit(now, title, goalamount: goalamount);
      now = now.add(Duration(days: day));
    }
  }

  void stepcounter(int totalReps, int day, String title, {int goalamount = 0}) {
    DateTime now = DateTime.now();
    for(var i = 1; i <= totalReps; i++) {
      addHabit(now, title, goalamount: goalamount, stepcounter: true);
      now = now.add(Duration(days: day));
    }
    db!.updateHabits(this);
    notifyListeners();
  }

  void startStepCounterToday() {
    steps!.start();
  }

  void updateStepCounter() {
    currentstepforDay = steps!.realStepsCounter;
    db!.updateHabits(this);
    notifyListeners();
  }

  void updateStepCounterHabit(Habit habit) {
    habit.steps(currentstepforDay);
    db!.updateHabits(this);
    notifyListeners();
  }
}