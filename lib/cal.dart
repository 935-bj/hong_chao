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
  var roomnum;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    fetchData();
  }

  void fetchData() {
    dbRef.once().then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            (snapshot.snapshot.value as Map<dynamic, dynamic>?);

        if (data != null) {
          setState(() {
            erate = data['erate'] ?? 0;
            wrate = data['wrate'] ?? 0;
            roomFee = data['roomFee'] ?? 0;
            otherFee = data['otherFee'] ?? 0;
          });

          dbRef
              .child('$roomnum')
              .child('e1')
              .once()
              .then((DatabaseEvent? snapshot) {
            if (snapshot != null && snapshot.snapshot.value != null) {
              Map<dynamic, dynamic>? e1 =
                  (snapshot.snapshot.value as Map<dynamic, dynamic>?);

              if (e1 != null) {
                int thisValue = e1['this'] ?? 0;
                int prevValue = e1['prev'] ?? 0;
                setState(() {
                  eUse = thisValue - prevValue;
                  print('finish calculated eUse: $eUse');
                });

                dbRef
                    .child('$roomnum')
                    .child('w1')
                    .once()
                    .then((DatabaseEvent? snapshot) {
                  if (snapshot != null && snapshot.snapshot.value != null) {
                    Map<dynamic, dynamic>? w1 =
                        (snapshot.snapshot.value as Map<dynamic, dynamic>?);

                    if (w1 != null) {
                      int thisValue = w1['this'] ?? 0;
                      int prevValue = w1['prev'] ?? 0;
                      setState(() {
                        wUse = thisValue - prevValue;
                        print('finish calculated wUse: $wUse');
                        display();
                        print('finished fetch room $roomnum data');
                      });
                    }
                  }
                });
              }
            }
          });
        }
      }
    });

    print(' call room $roomnum data');
    _roomnumController.clear();
  } //void fetchData()

  void display() {
    var total = eUse * erate + wUse * wrate + roomFee + otherFee;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  "สรุปค่าเช่า ห้อง $roomnum",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  '__________________',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  "ค่าน้ำ: $wrate บาท/หน่วย",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  "ใช้ไป: $wUse หน่วย",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  "ค่าไฟ: $erate บาท/หน่วย",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  "ใช้ไป: $eUse หน่วย",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  "ค่าห้อง: $roomFee บาท",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  "ค่าอื่นๆ: $otherFee บาท",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  '__________________',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  'Total Fee: $total',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  } //void display()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำณวนค่าเช่า'),
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
                  SingleChildScrollView(
                    child: Column(
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
                            onPressed: () {
                              roomnum = num.tryParse(_roomnumController.text);
                              fetchData();
                              print('wUse: $wUse, eUse: $eUse');
                            },
                            child: const Text('เรียกข้อมูล',
                                style: TextStyle(fontSize: 20))),
                      ],
                    ),
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
