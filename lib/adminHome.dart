import 'package:flutter/material.dart';
import 'package:hong_chao/login.dart';
import 'package:hong_chao/mgmtReport.dart';
import 'package:hong_chao/mgmtLawyerRegis.dart';
import 'package:hong_chao/mgmtPlaintiffRegis.dart';
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
        body: Stack(
          children: [
            Center(
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
                    child: const Text('Manage Report',
                        style: TextStyle(fontSize: 20)),
                  )),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    height: 45,
                    child: (ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, mgmtPlaintiffRegis.routeName);
                      },
                      child: const Text('Plaintiff Form',
                          style: TextStyle(fontSize: 20)),
                    ))),
                const SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    height: 45,
                    child: (ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, mgmtLawyerRegis.routeName);
                      },
                      child: const Text('Lawyer Form',
                          style: TextStyle(fontSize: 20)),
                    ))),
              ],
            )),
            Positioned(
                bottom: 16,
                right: 16,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        login.routeName, (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.deepPurple.shade100),
                  ),
                ))
          ],
        ));
  }
}
