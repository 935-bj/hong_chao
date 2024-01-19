import 'dart:ffi';
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/oldhome.dart';
import 'package:hong_chao/login.dart';

class oldLogin extends StatefulWidget {
  static String routeName = '/oldLogin';
  const oldLogin({super.key});

  @override
  State<oldLogin> createState() => _loginState();
}

class _loginState extends State<oldLogin> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference dbRef;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    dbRef = FirebaseDatabase.instance.ref();
  }

  void to_home(BuildContext context) {
    Navigator.pushNamed(context, login.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                'Welcome to Lawbizcase',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 5),
              const Text(
                'please oldLogin to start',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _mailController,
                  decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 225, 207, 243),
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 18))),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _mailController,
                  decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 225, 207, 243),
                      filled: true,
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: 18))),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => to_home(context),
                  child: const Text('Login', style: TextStyle(fontSize: 20)))
            ],
          ),
        ));
  }
}
