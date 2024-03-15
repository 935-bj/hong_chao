import 'package:flutter/material.dart';

class UpdateDialog {
  static Future<void> showUpdateDialog(BuildContext context, Map<String, dynamic> postDetail) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to update post ${postDetail['postID']}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Update'),
              onPressed: () {
                // Implement your update logic here
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}