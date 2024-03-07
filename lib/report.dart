import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'authService.dart';
import 'package:hong_chao/home.dart';

class report extends StatefulWidget {
  //static String routeName = '/report';
  final String postID;
  final String postData;
  const report({Key? key, required this.postID, required this.postData})
      : super(key: key);
  //const report({super.key});

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  late DatabaseReference dbRef;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> sendForm(String content) async {
    dbRef.child('reportPost').push().update({
      'uid': AuthService.currentUser!.uid,
      'pid': widget.postID,
      'timestamp': DateTime.now().toString(),
      'content': content,
      'postData': widget.postData
    });
    //await dbRef.child('reportPost').child(key!).update(reportData);
    print('finished report post;');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Report post'),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (_reportController != null) {
                  sendForm(_reportController.text);
                  _reportController.clear();
                  Navigator.pushNamed(context, home.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('report description cannot leave blank',
                          style: TextStyle(fontSize: 18)),
                      duration: Duration(seconds: 10),
                    ),
                  );
                }
              },
              child: const Text('send'))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _reportController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: 'describe what went wrong?',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0, color: Colors.deepPurple))),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}