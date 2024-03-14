import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/Bidding.dart';
import 'package:hong_chao/adminHome.dart';
import 'package:hong_chao/login.dart';
import 'package:hong_chao/home.dart';
import 'package:hong_chao/authService.dart';
import 'package:hong_chao/OpenCase.dart';
import 'package:hong_chao/mgmtReport.dart';
import 'package:hong_chao/manageRegis.dart';
import 'package:hong_chao/postScreen.dart';
import 'package:hong_chao/regisL.dart';
import 'package:hong_chao/regisP.dart';
import 'package:hong_chao/editPost.dart';
import 'package:hong_chao/Bidding.dart';
import 'package:hong_chao/joinPaintiff.dart';
import 'package:hong_chao/rateLawyer.dart';


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
        home.routeName: ((context) => const home()),
        regisP.routeName: ((context) => const regisP()),
        regisL.routeName: ((context) => const regisL()),
        OpenCase.routeName: (context) => const OpenCase(
              postDetail: {},
            ),
        postScreen.routeName: ((context) => const postScreen()),
        rateLawyer.routeName: ((context) => const rateLawyer()),
        //report.routeName: (context) => report(postID: ''),
        /*report.routeName: (context) {
          final Map args = ModalRoute.of(context)!.settings.arguments as Map;
          return report(postID: args['postID']);
        },*/
        //editPost.routeName: ((context) => const editPost()),
        editPost.routeName: (context) => const editPost(),
        adminHome.routeName: (context) => const adminHome(),
        mgmtReport.routeName: (context) => const mgmtReport(),
        manageRegis.routeName: (context) => const manageRegis(),
        BiddingScreen.routeName: (context) => const BiddingScreen(
              postDetail: {},
            ),
        JoinP.routeName: (context) => const JoinP(
              postDetail: {},
            ),
            
      },
      initialRoute: home.routeName,
    );
  }
}