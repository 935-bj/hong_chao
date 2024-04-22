import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/OpenCase.dart';
import 'package:hong_chao/authService.dart';
import 'package:hong_chao/editPost.dart';
import 'package:hong_chao/report.dart';

class myPost extends StatefulWidget {
  static String routeName = '/myPost';
  const myPost({super.key});

  @override
  State<myPost> createState() => _myPostState();
}

class _myPostState extends State<myPost> {
  late DatabaseReference dbRef;
  List<Map<String, dynamic>> postDetailsList = [];
  final String myUid = AuthService.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _fetchData();
  }

  void _fetchData() {
    postDetailsList.clear();
    dbRef.child('Post').onValue.listen((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> postData = snapshot.snapshot.value as Map;
        postData.forEach(
          (key, value) {
            Map<dynamic, dynamic> postDetails = value as Map;

            // Access the agreeList directly from the postDetails
            List<String> agreeList = [];

            if (postDetails.containsKey('agreeList')) {
              Map<dynamic, dynamic> agreeMap =
                  postDetails['agreeList'] as Map<dynamic, dynamic>;
              agreeList = agreeMap.keys.cast<String>().toList();
            }

            Map<String, dynamic> postMap = {
              'postID': key,
              'author': postDetails['author'],
              'uid': postDetails['uid'],
              'content': postDetails['content'],
              'timestamp': postDetails['timestamp'],
              'agreeList': agreeList
            };

            setState(() {
              if (myUid == postMap['uid']) {
                postDetailsList.add(postMap);
              }
            });
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Lawbizcase'),
        ),
      ),
      body: ListView.builder(
          itemCount: postDetailsList.length,
          itemBuilder: (context, index) {
            if (index < 0 || index >= postDetailsList.length) {
              // Debugging: Print the problematic index
              print('Invalid index: $index');
              return Container();
            }

            Map<String, dynamic> postDetail = postDetailsList[index];

            String time = postDetail['timestamp'].toString();

            String formattedTime = time.substring(0, time.length - 10);
            return Card(
              //กล่อง
              child: ListTile(
                title: Text(
                  postDetail['content'] ??
                      '', // Use an empty string if postDetail['content'] is null
                  style: const TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(
                    '${postDetail['agreeList'].length} agree • ${postDetail['author'].toString()} • $formattedTime'),
                //Text(postDetail['content'],style: TextStyle(fontSize: 18.0),),

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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You agree to this post already!',
                                    style: TextStyle(fontSize: 18)),
                                duration: Duration(seconds: 10),
                              ),
                            );
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
                          _to_report(
                              postDetail['postID'], postDetail['content']);

                          print('heading to report');
                        },
                      ),
                    );

                    // If the current user is owner of the post,
                    //beside Agree they can make it a case, edit, delete
                    if (AuthService.currentUser?.uid == postDetail['uid']) {
                      //make this post to case
                      items.add(
                        PopupMenuItem<String>(
                          value: 'Make this post to case',
                          child: const Text('Make this post to case'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OpenCase(postDetail: postDetail),
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
                            Navigator.pushNamed(context, editPost.routeName,
                                arguments: editPostArg(postDetail['postID']));
                            print('edit clicked');
                          },
                        ),
                      );
                      //delete post
                      items.add(
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: const Text('Delete'),
                          onTap: () {
                            print('tab delete');
                            _deleteDialog(postDetail['postID'].toString());
                          },
                        ),
                      );
                    }

                    return items;
                  },
                ),
              ),
            );
          }),
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
  }
}
