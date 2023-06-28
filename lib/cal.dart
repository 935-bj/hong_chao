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
  }

  @override
  Widget build(BuildContext context) {
    var total = eUse + wUse;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ค่าเช่าห้อง 1'),
      ),
      body: Column(
        children: [
          //call erate
          Expanded(
            child: FirebaseAnimatedList(
                query: dbRef.child('erate'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int indext) {
                  int data = snapshot.value as int;
                  erate = data;
                  return callERate(data: data);
                }),
          ),
          //call wrate
          Expanded(
            child: FirebaseAnimatedList(
                query: dbRef.child('wrate'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int indext) {
                  int data = snapshot.value as int;
                  return callWRate(data: data);
                }),
          ),
          //call e used info
          Expanded(
            child: FirebaseAnimatedList(
                query: dbRef.child('e1'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int indext) {
                  Map edata = snapshot.value as Map;
                  return cal_e(edata: edata);
                }),
          ),
          //call w used info
          Expanded(
            child: FirebaseAnimatedList(
                query: dbRef.child('w1'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int indext) {
                  Map wdata = snapshot.value as Map;
                  return cal_w(wdata: wdata);
                }),
          ),
        ],
      ),
    );
  }

//method
  Widget cal({required Map edata}) {
    return Column(
      children: [cal_e(edata: edata)],
    );
  }

  Widget cal_w({required Map wdata}) {
    int thisMonth = wdata['this'];
    int prevMonth = wdata['prev'];

    var use = thisMonth - prevMonth;

    wUse = use * wrate;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: Colors.deepPurple[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              use.toString(),
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  Widget cal_e({required Map edata}) {
    int thisMonth = edata['this'];
    int prevMonth = edata['prev'];

    var use = thisMonth - prevMonth;
    eUse = use * erate;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: Colors.deepPurple[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              use.toString(),
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  Widget callWRate({required int data}) {
    wrate = data;
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

  Widget callERate({required int data}) {
    erate = data;
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
