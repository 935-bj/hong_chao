import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class sum extends StatefulWidget {
  static String routeName = '/sum';
  const sum({super.key});

  @override
  State<sum> createState() => _sumState();
}

class _sumState extends State<sum> {
  final TextEditingController _roomnumController = TextEditingController();
  late DatabaseReference dbRef;
  var roomnum;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  void fetchData() {
    dbRef
        .child('$roomnum')
        .child('e1_record')
        .once()
        .then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map erecord = snapshot.snapshot.value as Map;
        print(erecord);
        return display(data: erecord);
      }
    });
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
                    },
                    child: const Text('เรียกข้อมูล',
                        style: TextStyle(fontSize: 20)))
              ],
            ),
          )
        ],
      ),
    );
  }

  void display({required Map data}) {
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
                Column(
                  children: [display_e(data: data)],
                )
              ],
            ),
          ),
        );
      },
    );
  }
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
