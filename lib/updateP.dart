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

    bool hasSelection = false;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Update'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Would you like to update case process ${postDetail['postID']}?'),
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
                          // Implement your logic here for handling the update
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