import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/home.dart';

class editPost extends StatefulWidget {
  static String routeName = "/editPost";
  const editPost({super.key});

  @override
  State<editPost> createState() => _editPostState();
}

class _editPostState extends State<editPost> {
  late DatabaseReference dbRef;
  //controller
  late final TextEditingController _postController;
  final _formKey = GlobalKey<FormState>();

  @override
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _postController = TextEditingController();

    _getPostContent('1706169914297').then((postContent) {
      setState(() {
        _postController.text = postContent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('edit post'),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                print('post content: ${_postController.text}');
                dbRef.child('Post').child('1706169914297').update({
                  'content': _postController.text,
                });
                Navigator.pushNamed(context, home.routeName);
                _postController.clear();
              },
              child: const Text('save'))
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

  Future<String> _getPostContent(String postID) async {
    try {
      DataSnapshot snapshot =
          await dbRef.child('Post').child(postID).child('content').get();

      if (snapshot.exists) {
        String postData = snapshot.value.toString();
        return postData;
      } else {
        throw "Post not found";
      }
    } catch (e) {
      // Handle the error
      print("Error: $e");
      rethrow; // Rethrow the error to propagate it to the calling code
    }
  }
}
