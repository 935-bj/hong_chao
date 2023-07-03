import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class sum extends StatefulWidget {
  static String routeName = '/sum';
  const sum({super.key});

  @override
  State<sum> createState() => _sumState();
}

class _sumState extends State<sum> {
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
        title: const Text('ประวัติการใช้ไฟ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: FirebaseAnimatedList(
                  query: dbRef.child('e1_record'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int indext) {
                    Map erecord = snapshot.value as Map;
                    return display(data: erecord);
                  }))
        ],
      ),
    );
  }

  Widget display({required Map data}) {
    return Column(
      children: [display_e(data: data)],
    );
  }

  Widget display_e({required Map data}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: Colors.deepPurple[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.toString(),
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
