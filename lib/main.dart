import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/home.dart';
import 'package:hong_chao/wbill.dart';
import 'package:hong_chao/ebill.dart';
import 'package:hong_chao/seting.dart';
import 'package:hong_chao/sum.dart';
import 'package:hong_chao/wsum.dart';

import 'cal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
        home.routeName: (context) => const home(),
        wbill.routeName: (context) => const wbill(),
        ebill.routeName: (context) => const ebill(),
        seting.routeName: (context) => const seting(),
        sum.routeName: (context) => const sum(),
        wsum.routeName: (context) => const wsum(),
        cal.routeName: (context) => const cal(),
      },
      initialRoute: home.routeName,
    );
  }
}
