import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'home.dart';

class login extends StatefulWidget {
  static String routeName = '/login';
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference dbRef;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    dbRef = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawbizcase'),
      ),
      //body: _user != null ? _userInfo() : _googleSignIn(),

      //เปลี่ยนจาก call _userInfo() เป็น call page อื่นๆ ได้เรยนิ่ :)
      body: _user != null ? _to_home() : _googleSignIn(),
    );
  }

  Widget _googleSignIn() {
    return Center(
      child: SizedBox(
          height: 50,
          child: SignInButton(Buttons.google,
              text: "Sign Up with Google", onPressed: _handSignIn)),
    );
  }

  Widget _to_home() {
    //Navigator.pushNamed(context, home.routeName);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => home(auth: _auth, user: _user),
        ));
    return Container();
  }

  Widget _userInfo() {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Loged in leaw'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            onPressed: () => _auth.signOut(),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _user!.photoURL != null
                      ? NetworkImage(_user!.photoURL!)
                      : const NetworkImage(
                          'https://photos.app.goo.gl/eU38zsmwbFuG8XXM8'),
                ),
              ),
            ),
            Text(_user!.email!),
            SizedBox(
              width: 10,
            ),
            Text(_user!.displayName ?? "no display name"),
          ],
        ),
      ),
    );
  }

  void _handSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}
