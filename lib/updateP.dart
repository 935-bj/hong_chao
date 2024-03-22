import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UpdateDialog {
  static final dbRef = FirebaseDatabase.instance.ref().child('OpenCase');

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

    bool hasSelection = false;

    // Retrieve existing selections from the database
    DatabaseEvent event = await dbRef.child(postDetail['postID']).child('case process').once();

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;
      if (values != null) {
        selection.forEach((key, value) {
          if (values.containsKey(key)) {
            selection[key] = values[key] as bool;
          }
        });
        hasSelection = selection.containsValue(true);
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('UPDATE CASE'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Would you like to update case?'),
                    //Text('Would you like to update post ${postDetail['postID']}?'),
                    SizedBox(height: 10),
                    // Add checkboxes for each selection
                    for (var entry in selection.entries)
                      ListTile(
                        title: Text(entry.key),
                        leading: Checkbox(
                          value: selection[entry.key],
                          onChanged: (value) {
                            setState(() {
                              selection[entry.key] = value!;
                              hasSelection = selection.containsValue(true);
                            });
                          },
                          shape: CircleBorder(),
                        ),
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
                TextButton(
                  child: Text('Update'),
                  onPressed: hasSelection
                      ? () {
                          // Update the selection in the database
                          dbRef.child(postDetail['postID']).child('case process').set(selection);
                          Navigator.of(context).pop();
                          // Perform update action
                        }
                      : null,
                ),
              ],
            );
          },
        );
      },
    );
  }
}