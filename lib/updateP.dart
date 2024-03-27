import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'authService.dart';

class UpdateDialog {
  static final dbRef = FirebaseDatabase.instance.ref().child('OpenCase');
  static final notiRef = FirebaseDatabase.instance.ref().child('noti');

  static Future<void> showUpdateDialog(
      BuildContext context, Map<String, dynamic> postDetail) async {
    // Initialize selection variables
    Map<String, bool> selection = {
      'Case Initiation': false,
      'Evidence Gathering': false,
      'Court Filings': false,
      'Negotiation and Settlement': false,
      'Pretrial Preparation': false,
      'Post-Trial Action': false,
      'Case Closure': false,
      'Finish Case': false,
    };

    bool hasSelection = false;

    //String curUid = AuthService.currentUser!.uid;

    // Retrieve existing selections from the database
    DatabaseEvent event =
        await dbRef.child(postDetail['postID']).child('case process').once();
    DatabaseEvent notiEvent =
        await notiRef.child(postDetail['postID']).child('case process').once();

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic>? values =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (values != null) {
        selection.forEach((key, value) {
          if (values.containsKey(key)) {
            selection[key] = values[key] as bool;
          }
        });
        hasSelection = selection.containsValue(true);
      }
    }

    if (notiEvent.snapshot.value != null) {
      Map<dynamic, dynamic>? values =
          notiEvent.snapshot.value as Map<dynamic, dynamic>?;
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
                          dbRef
                              .child(postDetail['postID'])
                              .child('case process')
                              .set(selection);
                          notiRef
                              .child(postDetail['postID'])
                              .child('case process')
                              .set(selection);
                          Navigator.of(context).pop();
                          // Perform update action

                          postDetail['from'] = selection.toString();
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

static Future<void> showNotiDialog(
    BuildContext context, Map<String, dynamic> postDetail) async {
  // Initialize selection variables
  Map<String, bool> selection = {
    'Case Initiation': false,
    'Evidence Gathering': false,
    'Court Filings': false,
    'Negotiation and Settlement': false,
    'Pretrial Preparation': false,
    'Post-Trial Action': false,
    'Case Closure': false,
    'Finish Case': false,
  };

  bool hasSelection = false;

  DatabaseEvent notiEvent =
      await notiRef.child(postDetail['postID']).child('case process').once();

  if (notiEvent.snapshot.value != null) {
    Map<dynamic, dynamic>? values =
        notiEvent.snapshot.value as Map<dynamic, dynamic>?;
    if (values != null) {
      selection.forEach((key, value) {
        if (values.containsKey(key)) {
          selection[key] = values[key] as bool;
        }
      });
      hasSelection = selection.containsValue(true);
    }
  }

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Status'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Status has been updated'),
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
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
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