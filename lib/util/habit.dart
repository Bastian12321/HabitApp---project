class Habit {
  final String title;
  final int? goalamount;
  int _amount = 0;
  bool _done = false;

  Habit(this.title, {this.goalamount});

  bool get done => _done;

  void complete() {
    _done = true;
  }

  void incomplete() {
    _done = false;
  }

  void increaseAmount() {
    _amount++;
    if (_amount == goalamount) {
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
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      map['title'],
      goalamount: map['goalamount'],
    )
    .._amount = map['amount'] ?? 0
    .._done = map['done'] ?? false;
  }
  
  Habit clone() {
    return Habit(
      title,
      goalamount: goalamount,
    )
    .._amount = _amount
    .._done = _done;
  }

  @override
  String toString() => title;
}