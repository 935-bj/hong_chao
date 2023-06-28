import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class cal extends StatefulWidget {
  static String routeName = '/cal';

  const cal({super.key});

  @override
  State<cal> createState() => _calState();
}

class _calState extends State<cal> {
  late DatabaseReference dbRef;
  var eUse = 0;
  var wUse = 0;
  var erate = 0;
  var wrate = 0;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    fetchData();
  }

  void fetchData() {
    dbRef.once().then((DatabaseEvent? snapshot) {
      Map<dynamic, dynamic>? data =
          (snapshot!.snapshot.value as Map<dynamic, dynamic>);
      //print(data['erate']);
      //print(data['e1']);
      setState(() {
        erate = data['erate'];
        wrate = data['wrate'];
      });

      dbRef.child('e1').once().then((DatabaseEvent? snapshot) {
        Map<dynamic, dynamic>? e1 =
            (snapshot!.snapshot.value as Map<dynamic, dynamic>);
        //print(data['erate']);
        //print(e1['prev']);
        setState(() {
          eUse = e1['this'] - e1['prev'];
        });
      });

      dbRef.child('w1').once().then((DatabaseEvent? snapshot) {
        Map<dynamic, dynamic>? w1 =
            (snapshot!.snapshot.value as Map<dynamic, dynamic>);
        //print(data['erate']);
        //print(w1['prev']);
        setState(() {
          wUse = w1['this'] - w1['prev'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var total = eUse * erate + wUse * wrate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ค่าเช่าห้อง 1'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  2, // Set the width of the purple area
              padding: const EdgeInsets.all(15.0),
              color: Colors.deepPurple[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "water rate: $wrate",
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "used: $wUse unit",
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "water rate: $erate",
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "used: $eUse unit",
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '__________________',
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Fee: $total',
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
