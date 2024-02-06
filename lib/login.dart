//import 'dart:js_interop';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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

    /*_auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });*/
    dbRef = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawbizcase'),
      ),
      body: AuthService.currentUser != null ? _to_home() : _googleSignIn(),
    );
  }

  Widget _googleSignIn() {
    return Center(
      child: SizedBox(
          height: 50,
          child: SignInButton(Buttons.google, text: "Sign Up with Google",
              onPressed: () {
            AuthService.signInWithGoogle();
          })),
    );
  }

  /*Widget _to_home() {
    //Navigator.pushNamed(context, home.routeName);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => home(
              auth: AuthService.authInstance, user: AuthService.currentUser),
        ));
    return Container();
  }*/
  Widget _to_home() {
    Navigator.pushReplacementNamed(context, home.routeName);
    return Container();
  }
}
