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
  final _formKey = GlobalKey<FormState>();
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

//ใส่เลขมืเตอ-ห้อง1
  Future<void> setData(num data) async {
    //call data from 'this' as prev
    Object? prev;
    await dbRef.child('e1').child('this').once().then((DatabaseEvent event) {
      prev = event.snapshot.value;
    });

    //store prev to 'prev'
    await dbRef.child('e1').update({'prev': prev});

    //store new 'this'
    await dbRef.child('e1').update({'this': data});

    DateTime now = DateTime.now();
    String timestamp = DateFormat('dd MMMM yyyy HH:mm:ss').format(now);

    //store to record
    await dbRef.child('e1_record').push().set({timestamp: data});
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
        title: const Text('HongChao'),
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
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: TextFormField(
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
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_textEditingController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('กรุณาใส่ข้อมูลให้ครบทุกช่อง'),
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                num? data = num.tryParse(_textEditingController.text);
                if (data != null) {
                  setData(data);
                  _textEditingController.clear();
                }
              }
            },
            child: const Text('เสร็จ'),
          ),
        ],
      ),
    );
  }
}
