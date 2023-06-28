import 'package:flutter/material.dart';
import 'package:hong_chao/ebill.dart';
import 'package:hong_chao/seting.dart';
import 'package:hong_chao/wbill.dart';
import 'package:hong_chao/sum.dart';
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

  void to_cal(BuildContext context) {
    Navigator.pushNamed(context, cal.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HongChao'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () => to_E(context),
              child: const Text('ใส่เลขมเตอร์ไฟ'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => to_W(context),
              child: const Text('ใส่เลขมิเตอร์น้ำ'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => to_sum(context),
              child: const Text('คำณวนค่าเช่า'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => to_sum(context),
              child: const Text('ดูประวัติฯ'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => to_S(context), child: const Text('ตั้งค่า'))
          ]),
        ));
  }
}
