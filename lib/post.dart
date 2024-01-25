import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/authService.dart';

class post {
  //createPost
  static Future<void> createPost(DatabaseReference dbRef, String uid,
      String name, String content, String location) async {
    var postID = DateTime.now().millisecondsSinceEpoch.toString();
    DatabaseReference nameRef = FirebaseDatabase.instance
        .ref('user/${AuthService.currentUser!.uid}/name');
    nameRef.onValue.listen((DatabaseEvent event) {
      final name = event.snapshot.value;
    });

    await dbRef.child(postID).update({
      'uid': uid,
      'author': name,
      'timestamp': DateTime.now().toString(),
      'content': content,
      'location': location,
    });
  }
}
