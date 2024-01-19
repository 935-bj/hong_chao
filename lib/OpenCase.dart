import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OpenCase extends StatefulWidget {
  static String routeName = '/OpenCase';
  const OpenCase({super.key});

  @override
  State<OpenCase> createState() => _OpenCaseState();
}

class _OpenCaseState extends State<OpenCase>{
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (appBar: AppBar(title: const Center(
          child: Text('Loged in leaw'),
        ),
         ),);
  }
}