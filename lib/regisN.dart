import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class regisN extends StatefulWidget {
  static String routeName = '/regisN';
  final FirebaseAuth auth;
  final User? user;

  const regisN({Key? key, required this.auth, required this.user})
      : super(key: key);

  @override
  State<regisN> createState() => _regisNState();
}

class _regisNState extends State<regisN> {
  late DatabaseReference dbRef;
  //controller

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
