import 'package:flutter/material.dart';
import 'package:hong_chao/mgmtReport.dart';
//import 'authService.dart';

class adminHome extends StatelessWidget {
  static String routeName = '/adminHome';
  const adminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Admin'),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 45,
            child: (ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, mgmtReport.routeName);
              },
              child:
                  const Text('Manage Report', style: TextStyle(fontSize: 20)),
            )),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: 300,
              height: 45,
              child: (ElevatedButton(
                onPressed: () {},
                child: const Text('Plaintiff Form',
                    style: TextStyle(fontSize: 20)),
              ))),
          const SizedBox(height: 20),
          SizedBox(
              width: 300,
              height: 45,
              child: (ElevatedButton(
                onPressed: () {},
                child:
                    const Text('Lawyer Form', style: TextStyle(fontSize: 20)),
              ))),
        ],
      )),
    );
  }
}
