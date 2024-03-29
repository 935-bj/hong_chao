import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class notiScreen extends StatefulWidget {
  final String caseID;
  final String timestamp;
  
  const notiScreen({Key? key, required this.caseID, required this.timestamp}) : super(key: key);

  @override
  State<notiScreen> createState() => _notiScreenState();
}

class _notiScreenState extends State<notiScreen> {
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Screen'),
      ),
      body: Center(
        child: Text('Notification screen for case ID: ${widget.timestamp}'),
      ),
    );
  }
}
