class Habit {
  final String title;
  final int? goalamount;
  final double? goalduration;
  int _amount = 0;
  double _duration = 0;
  bool _done = false;

  Habit(this.title, {this.goalamount, this.goalduration});

  bool get done => _done;

  void complete() {
    _done = true;
  }

  void incomplete() {
    _done = false;
  }

  void increaseAmount() {
    _amount++;
    if (_amount == goalamount!) {
      complete();
    }
  }
   void decreaseAmount() {
    if (_amount > 0) {
      _amount--;
    }
    if (_amount < goalamount! && done) {
      incomplete();
    }
  }

  void updateDuration(double duration) {
    _duration = duration;
    if (this.duration >= goalduration!) {
      complete();
    }
  }

  int get amount => _amount;

  double get duration => _duration;

  @override
  String toString() => title;
}