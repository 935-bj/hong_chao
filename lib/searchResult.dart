import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/OpenCase.dart';
import 'package:hong_chao/authService.dart';
import 'package:hong_chao/editPost.dart';
import 'package:hong_chao/home.dart';
import 'package:hong_chao/report.dart';

class searchResult extends StatefulWidget {
  const searchResult({super.key, required this.searchQ});
  static String routeName = '/searchResult';
  final String searchQ;

  @override
  State<searchResult> createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('OpenCase');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance.ref('Post'),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                final content = snapshot.child('content').value.toString();
                if (widget.searchQ.isEmpty) {
                  return const SizedBox(
                    height: 0.1,
                  );
                } else if (content.toLowerCase().contains(widget.searchQ)) {
                  Map postDetail = snapshot.value as Map;
                  String time = postDetail['timestamp'].toString();
                  String formattedTime = time.substring(0, time.length - 10);
                  return Card(
                    child: ListTile(
                      title: Text(
                        postDetail['content'] ??
                            '', // Use an empty string if postDetail['content'] is null
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      subtitle: Text(
                          '${postDetail['agreeList']?.length ?? 0} agree • ${postDetail['author'].toString()} • $formattedTime'),
                      trailing: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) {
                          List<PopupMenuEntry<String>> items = [];

                          // if currentUser != post owner, they can only click Agree, report

                          //agree
                          items.add(
                            PopupMenuItem<String>(
                              value: 'Agree',
                              child: const Text('Agree'),
                              // Empty onSelected handler
                              onTap: () {
                                String curUid = AuthService.currentUser!.uid;
                                if (!postDetail['agreeList'].contains(curUid)) {
                                  dbRef
                                      .child('Post')
                                      .child(postDetail['postID'].toString())
                                      .child('agreeList')
                                      .update({
                                    AuthService.currentUser!.uid:
                                        AuthService.currentUser!.uid
                                  }).then((_) {
                                    setState(() {
                                      postDetail['agreeList']
                                          .add(AuthService.currentUser!.uid);
                                    });
                                  }).catchError((e) {
                                    print('erroe: $e');
                                  });
                                } else {
                                  print(
                                      'current user already agree to this post');
                                }
                              },
                            ),
                          );

                          //report
                          items.add(
                            PopupMenuItem<String>(
                              value: 'Report',
                              child: const Text('Report'),
                              onTap: () {
                                _to_report(postDetail['postID'],
                                    postDetail['content']);

                                print('heading to report');
                              },
                            ),
                          );

                          // If the current user is owner of the post,
                          //beside Agree they can make it a case, edit, delete
                          if (AuthService.currentUser?.uid ==
                              postDetail['uid']) {
                            //make this post to case
                            items.add(
                              PopupMenuItem<String>(
                                value: 'Make this post to case',
                                child: const Text('Make this post to case'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OpenCase(
                                          postDetail: postDetail
                                              as Map<String, dynamic>),
                                    ),
                                  );
                                },
                              ),
                            );
                            //edit post
                            items.add(
                              PopupMenuItem<String>(
                                value: 'Edit',
                                child: const Text('Edit'),
                                // Empty onSelected handler
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, editPost.routeName,
                                      arguments:
                                          editPostArg(postDetail['postID']));
                                  print('edit clicked');
                                },
                              ),
                            );
                            //delete post
                            /**items.add(
                              PopupMenuItem<String>(
                                value: 'Delete',
                                child: const Text('Delete'),
                                onTap: () {
                                  print('tab delete');
                                  _deleteDialog(
                                      postDetail['postID'].toString());
                                },
                              ),
                            ); **/
                          }

                          return items;
                        },
                      ),
                    ),
                  );
                }
                //else
                else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _to_report(String pid, String postData) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => report(
                postID: pid,
                postData: postData,
              )),
    );
    print('route to report');
    return Container();
  }
/**
  Future<void> _deleteDialog(String key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this post?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Once this action is done'),
                Text('the post will be permanently delete'),
                Text('and cannot be undone. ')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                dbRef.child('Post').child(key.toString()).remove().then((_) {
                  // Remove the item from the local state
                  setState(() {
                    postDetailsList
                        .removeWhere((item) => item['postID'] == key);
                  });
                }).catchError((e) {
                  print(e);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } **/
}
