import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/authService.dart';

class myCase extends StatefulWidget {
  static String routeName = '/myCase';
  const myCase({super.key});

  @override
  State<myCase> createState() => _myCaseState();
}

class _myCaseState extends State<myCase> {
  late DatabaseReference dbRef;
  late List<Map<dynamic, dynamic>> _myCaseList = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('OpenCase');
    _fetchdata();
  }

  void _fetchdata() {
    _myCaseList.clear();
    dbRef.onValue.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
