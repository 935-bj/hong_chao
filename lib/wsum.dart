import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class wsum extends StatefulWidget {
  static String routeName = '/wsum';
  const wsum({super.key});

  @override
  State<wsum> createState() => _wsumState();
}

class _wsumState extends State<wsum> {
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
        title: const Text('HongChao'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: FirebaseAnimatedList(
                  query: dbRef.child('w1_record'),
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
      children: [display_w(data: data)],
    );
  }

  Widget display_w({required Map data}) {
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
