import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class wsum extends StatefulWidget {
  static String routeName = '/wsum';
  const wsum({super.key});

  @override
  State<wsum> createState() => _wsumState();
}

class _wsumState extends State<wsum> {
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
        .child('w1_record')
        .once()
        .then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map erecord = snapshot.snapshot.value as Map;

        // Convert the values to a list, reverse the order, and convert back to a map
        Map reversedData = Map.fromEntries(erecord.entries.toList().reversed);

        print(reversedData);
        return display(data: reversedData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการใช้น้ำ'),
        backgroundColor: const Color.fromARGB(255, 225, 207, 243),
      ),
      body: Column(
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
          const SizedBox(height: 10.0),
          ElevatedButton(
              onPressed: () {
                roomnum = num.tryParse(_roomnumController.text);
                fetchData();
                _roomnumController.clear();
              },
              child: const Text('เรียกข้อมูล', style: TextStyle(fontSize: 20)))
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
                Expanded(
                  child: Column(
                    children: [display_w(data: data)],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget display_w({required Map data}) {
    final values = data.values.toList(); // Convert map values to a list

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: values.map((value) {
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: 10.0), // Adjust the space as needed
              child: Text(
                value.toString(),
                style: const TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
