import 'package:flutter/material.dart';

class UpdateDialog {
  static Future<void> showUpdateDialog(BuildContext context, Map<String, dynamic> postDetail) async {
    // Initialize selection variables
    Map<String, bool> selection = {
      'Case Initiation': false,
      'Evidence Gathering': false,
      'Court Filings': false,
      'Negotiation and Settlement': false,
      'Pretrial Preparation': false,
      'Post-Trial Action': false,
      'Case Closure': false,
      'Case Finish': false,
    };

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to update post ${postDetail['postID']}?'),
                SizedBox(height: 10),
                // Add checkboxes for each selection
                for (var entry in selection.entries)
                  CheckboxListTile(
                    title: Text(entry.key),
                    value: selection[entry.key],
                    onChanged: (value) {
                      // Update selection when checkbox is changed
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Update'),
                            content: Text('You have selected ${entry.key}.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  // Implement your logic here for handling the selection
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
          actions: <Widget>[
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