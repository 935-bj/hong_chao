//import 'dart:js_interop';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/adminHome.dart';
import 'package:hong_chao/adminLogin.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:hong_chao/authService.dart';

import 'home.dart';

class login extends StatefulWidget {
  static String routeName = '/login';
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference dbRef;
  //User? _user;

  @override
  void initState() {
    super.initState();
    AuthService.initAuthState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lawbizcase'),
        ),
        body: Stack(
          children: [
            Center(
              child: AuthService.currentUser != null
                  ? _to_home()
                  : _googleSignIn(),
            ),
            Positioned(
                bottom: 16,
                right: 16,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, adminLogin.routeName);
                  },
                  child: Text(
                    'Admin Login',
                    style: TextStyle(color: Colors.deepPurple.shade100),
                  ),
                ))
          ],
        ));
  }

  Widget _googleSignIn() {
    return Center(
      child: SizedBox(
          height: 50,
          child: SignInButton(Buttons.google, text: "Sign in with Google",
              onPressed: () async {
            await AuthService.signInWithGoogle();
            if (AuthService.currentUser != null) {
              Navigator.pushReplacementNamed(context, home.routeName);
            }
          })),
    );
  }

  Widget _to_home() {
    Navigator.pushReplacementNamed(context, home.routeName);
    return Container();
  }
}
