import 'package:flutter/material.dart';
import 'package:habitapp/models/appUser.dart';
import 'package:habitapp/services/database.dart';
import 'package:habitapp/util/pending_namecheck.dart';
import 'package:provider/provider.dart';

class NewNameField extends StatefulWidget {
  final VoidCallback update;

  NewNameField({super.key, required this.update});
  
  @override
  _NewNameFieldState createState() => _NewNameFieldState();
}

class _NewNameFieldState extends State<NewNameField> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? username;

  bool checking = false;

  void toggleChecking() {
    setState(() {
      checking = !checking;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return checking ? PendingNamecheck(loading: true) : AlertDialog(
      backgroundColor: const Color(0xFF1D716F),
      content: Container(
        alignment: Alignment.center,
        height: 150,
        width: 300,
        child: checking ? null : Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'username cannot be empty';
                  }
                  if (val.length > 30 || val.length < 4) {
                    return 'must contain 4-30 characters';
                  } 
                  return null;
                },
                onChanged: (val) {
                  setState(() => username = val);
                },
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'username',
                  hintStyle: TextStyle(color: Colors.grey),
                  errorStyle: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                    ),
                  filled: true,
                  fillColor:Color.fromARGB(255, 228, 181, 176),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (user != null) {
                          toggleChecking();
                          Database db = Database(uid: user.uid);
                          bool available = await db.isUserNameAvailable(username!);
                          if (available) {
                            toggleChecking();
                            await db.updateUserName(username!);
                            widget.update(); 
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          } else {
                            if (mounted) {
                              showDialog(
                              context: context,
                                builder: (context) => PendingNamecheck(
                                  loading: false,
                                ),
                              ).then((_) {
                                if (mounted) {
                                  toggleChecking();
                                }
                              });
                            }
                          }
                        }
                      }
                    },
                    child: const Text('Accept'),
                    elevation: 15,
                    color: const Color.fromARGB(255, 232, 124, 112),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  const SizedBox(width: 40),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                    elevation: 15,
                    color: const Color.fromARGB(255, 232, 124, 112),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
