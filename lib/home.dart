import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/ebill.dart';
import 'package:hong_chao/login.dart';
import 'package:hong_chao/seting.dart';
import 'package:hong_chao/wbill.dart';
import 'package:hong_chao/sum.dart';
import 'package:hong_chao/wsum.dart';
import 'package:hong_chao/cal.dart';
import 'package:hong_chao/oldLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class home extends StatefulWidget {
  static String routeName = '/home';
  final FirebaseAuth auth;
  final User? user;

  const home({Key? key, required this.auth, required this.user})
      : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    print("User Email: ${widget.user?.email}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Loged in leaw'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app_rounded),
              onPressed: () {} //=> widget.auth.signOut(),
              ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.user!.photoURL != null
                      ? NetworkImage(widget.user!.photoURL!)
                      : const NetworkImage(
                          'https://photos.app.goo.gl/eU38zsmwbFuG8XXM8'),
                ),
              ),
            ),
            Text(widget.user!.email!),
            SizedBox(
              width: 10,
            ),
            Text(widget.user!.displayName ?? "no display name"),
          ],
        ),
      ),
    );
  }
}
