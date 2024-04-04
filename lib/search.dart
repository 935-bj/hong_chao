import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/authService.dart';

Widget search(TextEditingController searchController, DatabaseReference dbRef) {
  //DbRef = FirebaseDatabase.instance.ref('OpenCase')
  return Column(
    children: [
      TextFormField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search',
          border: OutlineInputBorder(),
        ),
      ),
      Expanded(
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            final content = snapshot.child('content').value.toString();
            //if
            if (searchController.text.isEmpty) {
              return const SizedBox(
                height: 0.1,
              );
            }
            //else if
            else if (content
                .toLowerCase()
                .contains(searchController.text.toLowerCase().toString())) {
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
                      '${postDetail['agreeList'].length} agree • ${postDetail['author'].toString()} • $formattedTime'),
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
                              print('current user already agree to this post');
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
            }
            //else
            else {
              return Container();
            }
          },
        ),
      ),
    ],
  );
}
