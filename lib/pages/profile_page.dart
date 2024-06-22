import 'dart:io';
import 'package:flutter/material.dart';
import 'package:habitapp/models/appUser.dart';
import 'package:habitapp/services/auth.dart';
import 'package:habitapp/services/database.dart';
import 'package:habitapp/util/new_username.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int habitsCompleted = 0;
  int totalNoOfHabits = 10;
  File? _image;
  String email = 'Loading email...';
  String username = 'Loading username...';

  final Auth _auth = Auth();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }



  Future<void> _loadUserdata() async {
    try {
      final currentUser = Provider.of<AppUser?>(context, listen: false);
      if (currentUser == null) {
        throw Exception('User not found');
      }

      final String uid = currentUser.uid;
      final Database database = Database(uid: uid);

      String usernameFromDatabase = await database.getUsername();
      String emailFromAuthenticator = _auth.getUserEmail()!;

      if (!mounted) return;

      setState(() {
        email = emailFromAuthenticator;
        username = usernameFromDatabase;
      });

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserdata();
  }


  void changeName(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) {
        return NewNameField(update: _loadUserdata);
      }
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TrackIt',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage('assets/images/ProfilePicture.png') as ImageProvider,
                  child: _image == null ? const Icon(Icons.add_a_photo, size: 40,) : null,
                ),
              ),
            ),
            const Divider(height: 60),
            const Text(
              'NAME',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontSize: 10,
              ),
            ),
            Row(
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    changeName(context);
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 25,
                    color: Colors.white
                  )
                )
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'EMAIL',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
