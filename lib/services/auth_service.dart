import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
  );

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    // Update the username
    await updateUsername(name, currentUser);
    return currentUser.uid;
  }

  Future updateUsername(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user.uid;
  }

  // Sign Out
  signOut(){
    return _firebaseAuth.signOut();
  }

  Future sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future signInAnonymously(){
    return _firebaseAuth.signInAnonymously();
  }

  Future convertUserWithEmail(String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();
    final credential = EmailAuthProvider.getCredential(email: email,password: password);
    await currentUser.linkWithCredential(credential);
    await updateUsername(name, currentUser);
  }

}

class EmailValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Email can't be empty";
    }
    return null;
  }
}

class NameValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Name can't be empty";
    }
    if(value.length <2){
      return "Name be at least 2 characters long";
    }
    if(value.length >50){
      return "Name be at less than 50 characters long";
    }
    return null;
  }
}

class PasswordValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Password can't be empty";
    }
    return null;
  }
}