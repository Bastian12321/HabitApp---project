import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitapp/models/appUser.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser; //TODO: skal nok fjernes

  AppUser? _appUserFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Stream<AppUser?> get appUser { 
    //bruger en stream til at tjekke efter 
    //authetication changes i programmet så vi kan holde
    //øje med hvornår users logger ind og ud.
    return _firebaseAuth.authStateChanges()
      .map(_appUserFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential cred = await _firebaseAuth.signInAnonymously();
      User? user = cred.user;
      return _appUserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges(); //TODO skal nok fjernes

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future createUserWithEmailAndPassword (String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      User? user = result.user;
      return _appUserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}