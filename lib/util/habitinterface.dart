import 'package:habitapp/util/habit.dart';

class HabitUI {

  Map<DateTime, List<Habit>> habits;

  HabitUI(): habits = {};


  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime get focusedDay => _focusedDay;

  void set focusedDay(DateTime day) {
    _focusedDay = day;
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