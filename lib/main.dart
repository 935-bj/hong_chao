import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/login.dart';
import 'package:hong_chao/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hong_chao/authService.dart';

//add OpenCase.dart
import 'package:hong_chao/OpenCase.dart';
import 'package:hong_chao/postScreen.dart';

import 'package:hong_chao/regisP.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  AuthService.initAuthState();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        login.routeName: (context) => const login(),
        home.routeName: ((context) => home()),
        regisP.routeName: ((context) => regisP()),
        //OpenCase.routeName: (context) => const OpenCase(),
        postScreen.routeName: ((context) => const postScreen()),
      },
      initialRoute: home.routeName,
    );
  }
}
