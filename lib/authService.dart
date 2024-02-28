import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/home.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? _user;

  static User? get currentUser => _user;

  static FirebaseAuth get authInstance => _auth;

  static void initAuthState() {
    _auth.authStateChanges().listen((event) {
      _user = event;
    });
  }

  static Future<void> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print('error: $e');
    }
  }

  Future<String?> username() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('user')
        .child(_user!.uid)
        .child('name');
    String? username;
    try {
      if (_user != null) {
        /*userRef.once().then((DatabaseEvent? snapshot) {
          username = snapshot?.snapshot.value as String;
        });*/

        DataSnapshot snapshot = (await userRef.once()) as DataSnapshot;
        username = snapshot.value as String?;
      }
    } catch (e) {
      print(e);
    }
    return username;
  }
}
