import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sensors/flutter_sensors.dart'; // Ensure you have the appropriate package



class Pedometer {
  bool _accelAvailable = false;
  List<double> _accelData = List.filled(3, 0.0);
  StreamSubscription? _accelSubscription;

  static const Duration intervalTime = Duration(microseconds: 25000);

  double _accelThreshold = 18.0;
  bool _isPeak = false;

  int realStepsCounter = 0;
  bool isWalking = false;
  int peakCounter = 0;
  int lastPeakCounter = 0;
  late Timer _timer;
  final int _checkPeriod = 10;
  final int _checkPeriodStepThreshold = 7;

  final VoidCallback onStateChange;

  Pedometer({required this.onStateChange});

  void start() {
    //_checkAccelerometerStatus();
    _startTimer();
  }

  void dispose() {
    _stopAccelerometer();
    _timer.cancel();
  }

  void _stopAccelerometer() {
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
  }

  void _checkAccelerometerStatus() async {
    final result = await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);
    _accelAvailable = result;
    onStateChange();
    if (_accelAvailable) {
      _startAccelerometer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: _checkPeriod), (timer) {
      detectGait();
    });
  }

  Future<void> _startAccelerometer() async {
    if (_accelSubscription != null) return;
    if (_accelAvailable) {
      final stream = await SensorManager().sensorUpdates(
        sensorId: Sensors.ACCELEROMETER,
        interval: intervalTime,
      );
      _accelSubscription = stream.listen((sensorEvent) {
        _accelData = sensorEvent.data;
        double magnitude = sqrt(
          _accelData[0] * _accelData[0] +
          _accelData[1] * _accelData[1] +
          _accelData[2] * _accelData[2]
        );
        detectPeak(magnitude);
      });
    }
  }

  void detectPeak(double magnitude) {
    if (magnitude > _accelThreshold && !_isPeak) {
      _isPeak = true;
      peakCounter++;
      if (isWalking) {
        realStepsCounter++;
        onStateChange();
      }
    } else if (magnitude <= _accelThreshold && _isPeak) {
      _isPeak = false;
    }
  }

  void detectGait() {
    if (peakCounter - lastPeakCounter >= _checkPeriodStepThreshold) {
      if (!isWalking) {
        realStepsCounter += (peakCounter - lastPeakCounter);
      }
      isWalking = true;
    } else {
      isWalking = false;
    }
    lastPeakCounter = peakCounter;
  }
}

