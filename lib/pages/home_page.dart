import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GoalGuard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: ElevatedButton(
          child: const Text("Add Habit"),
          onPressed: (){
            showDialog(
            context: context,
            builder: (_) {
              return MyDialog();
            });
          },
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            label: 'Habits'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends'       
          )         
          ],
        ),
      ),
    );
  }
}

const List<String> timeUnit = <String>['Days', 'Weeks', 'Months'];

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool? _isCheckedCheck = false;
  bool? _isCheckedTime = false;
  bool? _isCheckedAmount = false;

  String timeDropDownValue = timeUnit.first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: 
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: "Name of Habit"),
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text("✅"),
                  value: _isCheckedCheck,
                  onChanged: (bool? newValue){
                    setState(() {
                      _isCheckedCheck = newValue;
                      _isCheckedTime = false;
                      _isCheckedAmount = false;
                    });
                  }
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text("⏳"),
                  value: _isCheckedTime,
                  onChanged: (bool? newValue){
                    setState(() {
                      _isCheckedTime = newValue;
                      _isCheckedCheck = false;
                      _isCheckedAmount = false;
                    });
                  }
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text("🤏"),
                  value: _isCheckedAmount,
                  onChanged: (bool? newValue){
                    setState(() {
                      _isCheckedAmount = newValue;
                      _isCheckedTime = false;
                      _isCheckedCheck = false;
                    });
                  }
                ),
              ),
            ],
          ),
          if(_isCheckedTime == true)(
            TextField(
              decoration: InputDecoration(hintText: "Time in minutes"),
            )
          ),
          if(_isCheckedAmount == true)(
            TextField(
              decoration: InputDecoration(hintText: "Amount of subgoals"),
            )
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(hintText: "Frequency")
              ))
              ,
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child:  
                  DropdownButton<String>(
                    value: timeDropDownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        timeDropDownValue = value!;
                      });
                    },
                    items: timeUnit.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                  )
                ],
              ),
            ],
      ),
        
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('Cancel'),
                onPressed: () => setState(() {
                      Navigator.of(context).pop();
                    })),
            TextButton(
                child: const Text('Add'),
                onPressed: () => setState(() {
                      Navigator.of(context).pop();
                    })),
          ],
        )
      ],
    );
  }
}