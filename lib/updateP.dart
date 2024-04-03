import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'authService.dart';

import 'package:intl/intl.dart';

class UpdateDialog {
  static final dbRef = FirebaseDatabase.instance.ref().child('OpenCase');
  static final notiRef = FirebaseDatabase.instance.ref().child('OpenCase');

  static Future<void> showUpdateDialog(
      BuildContext context, Map<String, dynamic> postDetail) async {
    // Retrieve existing selections from the database
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

    DatabaseEvent event =
        await dbRef.child(postDetail['postID']).child('case process').once();

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

    DateTime now = DateTime.now();
    // Generate timestamp
    String timestamp = DateFormat('dd-MM-yyyy HH:mm').format(now);

    DatabaseEvent notiEvent = await notiRef
        .child(postDetail['postID'])
        .child('time')
        .child(timestamp)
        .child('case process')
        .once();

    if (notiEvent.snapshot.value != null) {
      Map<dynamic, dynamic>? values =
          notiEvent.snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        values = Map.fromEntries(
          values.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
        );

        selection.clear();

        values.forEach((key, value) {
          if (key is String && value is bool) {
            selection[key] = value;
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
                    SizedBox(height: 10),
                    // Add checkboxes for each selection
                    for (var entry in selection.entries)
                      ListTile(
                        title: Text(entry.key),
                        leading: Checkbox(
                          value: entry.value,
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
                              .child('noti')
                              .push()  // Use push to generate unique keys
                              .child('time') // Specify 'time' as a child
                              .set(timestamp);
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

  static Future<void> showNotiDialog(BuildContext context,
      Map<String, dynamic> postDetail, DataSnapshot snapshot) async {
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
                    Text(
                      'Status has been updated',
                      style: TextStyle(
                        color: Colors.red, // Change color to red
                        fontSize: 18, // Increase font size for prominence
                        fontWeight: FontWeight.bold, // Emphasize the status
                      ),
                    ),
                    SizedBox(height: 10), // Add space for separation
                    Text(
                      'Author: ${snapshot.child('author').value.toString()}',
                      style: TextStyle(
                        fontSize: 16, // Decrease font size slightly
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Winning lawyer: ${snapshot.child('minBids').child('minimunBids').child('author').value.toString()}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 30, 255),
                        fontSize: 16, // Keep font size consistent
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Case detail: ' +
                          snapshot.child('content').value.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Keep font size consistent
                      ),
                    ),
                    SizedBox(height: 10),
                    // Add checkboxes for each selection
                    for (var entry in selection.entries)
                      ListTile(
                        title: Text(entry.key),
                        leading: Checkbox(
                          value: entry.value,
                          onChanged: (value) {
                            // setState(() {
                            //   //selection[entry.key] = value!;
                            //   //hasSelection = selection.containsValue(true);
                            // });
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