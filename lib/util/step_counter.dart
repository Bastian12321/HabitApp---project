import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'dart:async';  
import 'package:habitapp/util/habitinterface.dart';
import 'package:habitapp/util/habit.dart';

class StepCounter extends StatefulWidget {
  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  late StreamSubscription<StepCount> _subscription;

  @override
  void initState() {
    super.initState();
    _initializePedometer();
  }

  void _initializePedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _subscription = _stepCountStream.listen(_onStepCount, onError: _onError);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _onStepCount(StepCount event) {
    final data = Provider.of<HabitUI>(context, listen: false);
    final habits = data.getHabitsForDay(data.currentDay);

    // Find the steps habit and update its amount
    final stepsHabit = habits.firstWhere(
        (habit) => habit.title.toLowerCase().contains('steps'),
        orElse: () => Habit(''));  // Return a dummy Habit object to satisfy the type requirement
    if (stepsHabit.title.isNotEmpty) {
      setState(() {
        stepsHabit.amount = event.steps; // Update the amount
        data.updateHabit(stepsHabit); // Notify provider
      });
    }
  }

  void _onError(error) {
    print('Step Count Error: $error');
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // This widget does not need to display anything
  }
}