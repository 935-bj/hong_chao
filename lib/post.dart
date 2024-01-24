import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class post {
  //createPost
  static Future<void> createPost(DatabaseReference dbRef, String uid,
      String name, String content, String location) async {
    var postID = DateTime.now().millisecondsSinceEpoch.toString();

    await dbRef.child(postID).update({
      'uid': uid,
      'author': name,
      'timestamp': DateTime.now().toString(),
      'content': content,
      'location': location,
    });
  }
}
