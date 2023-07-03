import 'package:flutter/material.dart';
import 'package:hong_chao/ebill.dart';
import 'package:hong_chao/seting.dart';
import 'package:hong_chao/wbill.dart';
import 'package:hong_chao/sum.dart';
import 'package:hong_chao/wsum.dart';
import 'package:hong_chao/cal.dart';

class home extends StatelessWidget {
  static String routeName = '/home';
  const home({super.key});

  void to_E(BuildContext context) {
    Navigator.pushNamed(context, ebill.routeName);
  }

  void to_W(BuildContext context) {
    Navigator.pushNamed(context, wbill.routeName);
  }

  void to_S(BuildContext context) {
    Navigator.pushNamed(context, seting.routeName);
  }

  void to_sum(BuildContext context) {
    Navigator.pushNamed(context, sum.routeName);
  }

  void to_wsum(BuildContext context) {
    Navigator.pushNamed(context, wsum.routeName);
  }

  void to_cal(BuildContext context) {
    Navigator.pushNamed(context, cal.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('ห้อง 1')),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 300,
                height: 45,
                child: (ElevatedButton(
                  onPressed: () => to_E(context),
                  child: const Text('ใส่เลขมิเตอร์ไฟ',
                      style: TextStyle(fontSize: 20)),
                ))),
            const SizedBox(height: 20),
            SizedBox(
                width: 300,
                height: 45,
                child: (ElevatedButton(
                  onPressed: () => to_W(context),
                  child: const Text('ใส่เลขมิเตอร์น้ำ',
                      style: TextStyle(fontSize: 20)),
                ))),
            const SizedBox(height: 20),
            SizedBox(
                width: 300,
                height: 45,
                child: (ElevatedButton(
                  onPressed: () => to_cal(context),
                  child: const Text('คำณวนค่าเช่า',
                      style: TextStyle(fontSize: 20)),
                ))),
            const SizedBox(height: 20),
            SizedBox(
                width: 300,
                height: 45,
                child: (ElevatedButton(
                  onPressed: () => to_sum(context),
                  child: const Text('ดูประวัติฯการใช้ไฟ',
                      style: TextStyle(fontSize: 20)),
                ))),
            const SizedBox(height: 20),
            SizedBox(
                width: 300,
                height: 45,
                child: (ElevatedButton(
                  onPressed: () => to_wsum(context),
                  child: const Text('ดูประวัติฯการใช้น้ำ',
                      style: TextStyle(fontSize: 20)),
                ))),
            const SizedBox(height: 20),
            SizedBox(
                width: 300,
                height: 45,
                child: (ElevatedButton(
                    onPressed: () => to_S(context),
                    child:
                        const Text('ตั้งค่า', style: TextStyle(fontSize: 20)))))
          ]),
        ));
  }
}
