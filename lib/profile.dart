import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class profile extends StatefulWidget {
  static String routeName = '/profile';
  final FirebaseAuth auth;
  final User? user;

  const profile({Key? key, required this.auth, required this.user})
      : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text('Profile'),
      )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Display user picture
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user?.photoURL ?? ''),
                radius: 50,
              ),
              SizedBox(height: 10),
              // Display user email
              Text(
                widget.user?.email ?? '',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Register as Lawyer',
                ),
              ),
              SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Text('Register as PLaintiff'),
              ),
              SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Text('Log out'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
