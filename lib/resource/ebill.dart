import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ebill extends StatefulWidget {
  static String routeName = '/ebill';

  const ebill({super.key});

  @override
  State<ebill> createState() => _ebillState();
}

class _ebillState extends State<ebill> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _roomnumController = TextEditingController();
  var roomnum;
  final _formKey = GlobalKey<FormState>();
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

//ใส่เลขมืเตอ-ห้อง $roomnum
  Future<void> setData(num data) async {
    //call data from 'this' as prev
    Object? prev;
    await dbRef
        .child('$roomnum')
        .child('e1')
        .child('this')
        .once()
        .then((DatabaseEvent event) {
      prev = event.snapshot.value;
    });

    //store prev to 'prev'
    await dbRef.child('$roomnum').child('e1').update({'prev': prev});

    //store new 'this'
    await dbRef.child('$roomnum').child('e1').update({'this': data});

    DateTime now = DateTime.now();
    String timestamp = DateFormat('dd MMMM yyyy HH:mm:ss').format(now);

    //store to record
    await dbRef
        .child('$roomnum')
        .child('e1_record')
        .push()
        .set({timestamp: data});
    print('finished update meter data');
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter meter data';
    } else if (value.length != 6) {
      return 'Please enter a 5-digit number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ห้อง 1'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Input electricity meter data',
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: _validateInput,
                    decoration: const InputDecoration(
                        fillColor: Color.fromARGB(255, 225, 207, 243),
                        filled: true,
                        hintText: 'เลขมิเตอร์ไฟ',
                        hintStyle: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_textEditingController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('กรุณาใส่ข้อมูลให้ครบทุกช่อง',
                        style: TextStyle(fontSize: 20)),
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                roomnum = num.tryParse(_roomnumController.text);
                num? data = num.tryParse(_textEditingController.text);
                _roomnumController.clear();
                if (data != null) {
                  setData(data);
                  _textEditingController.clear();
                }
              }
            },
            child: const Text('เสร็จ', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
