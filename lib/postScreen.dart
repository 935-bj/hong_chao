import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/home.dart';
import 'authService.dart';

class postScreen extends StatefulWidget {
  static String routeName = '/postScreen';
  const postScreen({super.key});

  @override
  State<postScreen> createState() => _postScreenState();
}

class _postScreenState extends State<postScreen> {
  late DatabaseReference dbRef;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> sendForm(
      String author, String content, String location, String postID) async {
    await dbRef.child('Post').child(postID).update({
      'uid': AuthService.currentUser!.uid,
      'author': author,
      'timestamp': DateTime.now().toString(),
      'content': content,
      'location': location,
    });
    print('finished update data ;');
  }

  Future<String?> getName() async {
    String? username;
    await dbRef
        .child('user')
        .child(AuthService.currentUser!.uid)
        .once()
        .then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            (snapshot.snapshot.value as Map<dynamic, dynamic>?);
        if (data != null) {
          username = data['name'];
          print(username);
        }
      }
    });
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('write post'),
        ),
        automaticallyImplyLeading: true,
        actions: [
          ElevatedButton(
              onPressed: () async {
                String postID =
                    DateTime.now().millisecondsSinceEpoch.toString();
                String? username = await getName();

                print('post content: ${_postController.text}');
                dbRef.child('Post').child(postID).update({
                  'content': _postController.text,
                  'location': '',
                  'timestamp': DateTime.now().toString(),
                  'uid': AuthService.currentUser!.uid,
                  'author': username
                });
                Navigator.pushNamed(context, home.routeName);
                _postController.clear();
              },
              child: const Text('Post'))
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
                      controller: _postController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: 'what happenning...',
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
