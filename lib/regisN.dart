import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class regisN extends StatefulWidget {
  static String routeName = '/regisN';
  final FirebaseAuth auth;
  final User? user;

  const regisN({Key? key, required this.auth, required this.user})
      : super(key: key);

  @override
  State<regisN> createState() => _regisNState();
}

class _regisNState extends State<regisN> {
  late DatabaseReference dbRef;
  final _formKey = GlobalKey<FormState>();
  //controller
  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> setName(
      String uid, String name, String mail, String type) async {
    await dbRef
        .child('user')
        .child(uid)
        .update({'name': name, 'mail': mail, 'type': type});
    print('finished update rate data ;');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('How should we call you'),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: 'your name'),
                    )
                  ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('name cannot leave blank',
                          style: TextStyle(fontSize: 20)),
                      duration: Duration(seconds: 10),
                    ),
                  );
                } else {
                  setName(widget.user!.uid, _nameController.text,
                      widget.user!.email.toString(), 'N');
                }
              },
              child: const Text('save'))
        ],
      ),
    );
  }
}
