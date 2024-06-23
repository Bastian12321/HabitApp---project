class Habit {
  final String title;
  int goalamount = 0;
  int _amount = 0;
  bool _done = false;
  final bool? stephabit;

  Habit(this.title, {this.goalamount = 0, this.stephabit = false});

  bool get done => _done;

  void steps(int steps) {
    _amount = steps;
    if(_amount == goalamount) {
      complete();
    }
  }

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

  int get amount => _amount;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'goalamount' : goalamount,
      'amount' : _amount,
      'done' : _done,
      'stephabit' : stephabit,
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      map['title'],
      goalamount: map['goalamount'] ?? 0,
      stephabit: map['stephabit']
    )
    .._amount = map['amount'] ?? 0
    .._done = map['done'] ?? false;
  }
  
   Habit clone() {
    return Habit(
      title,
      goalamount: goalamount,
      stephabit: stephabit,
    )
    .._amount = _amount
    .._done = _done;
  }

  @override
  String toString() => title;
}