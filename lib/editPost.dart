import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/home.dart';

class editPostArg {
  final String postID;
  editPostArg(this.postID);
}

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

  String postID = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //access argument
    final args = ModalRoute.of(context)!.settings.arguments as editPostArg;

    //check if postID change before fetch data
    if (postID != args.postID) {
      postID = args.postID;
      _getPostContent(postID).then((postContent) => {
            setState(() {
              _postController.text = postContent;
            })
          });
    }
  }
  //overide didChangeDependency to ensure that
  //ModalRoute.of(context) is executed after the initialization of the widget.

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _postController = TextEditingController();
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
                dbRef.child('Post').child(postID).update({
                  'content': _postController.text,
                });
                Navigator.of(context).pop();
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
