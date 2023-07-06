import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class cal extends StatefulWidget {
  static String routeName = '/cal';

  const cal({super.key});

  @override
  State<cal> createState() => _calState();
}

class _calState extends State<cal> {
  final TextEditingController _roomnumController = TextEditingController();
  late DatabaseReference dbRef;
  var eUse = 0;
  var wUse = 0;
  var erate = 0;
  var wrate = 0;
  var roomFee = 0;
  var otherFee = 0;

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
        roomFee = data['roomFee'];
        otherFee = data['otherFee'];
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
    var total = eUse * erate + wUse * wrate + roomFee + otherFee;

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                      controller: _roomnumController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 225, 207, 243),
                          filled: true,
                          hintText: 'ใส่เลขห้อง',
                          hintStyle: TextStyle(fontSize: 18))),
                  ElevatedButton(
                      onPressed: () => fetchData(),
                      child: const Text('เรียกข้อมูล',
                          style: TextStyle(fontSize: 20))),
                  const SizedBox(height: 100),
                  Text(
                    "ค่าน้ำ: $wrate บาท/หน่วย",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ใช้ไป: $wUse หน่วย",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ค่าไฟ: $erate บาท/หน่วย",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ใช้ไป: $eUse หน่วย",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ค่าห้อง: $roomFee บาท",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ค่าอื่นๆ: $otherFee บาท",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '__________________',
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Fee: $total',
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
