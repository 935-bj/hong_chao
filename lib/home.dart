import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hong_chao/postScreen.dart';
import 'package:hong_chao/regisL.dart';
import 'package:hong_chao/regisP.dart';
import 'package:hong_chao/OpenCase.dart';

import 'authService.dart';

class home extends StatefulWidget {
  static String routeName = '/home';
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late DatabaseReference dbRef;
  //controller
  final SearchController searrchController = SearchController();
  final TextEditingController postController = TextEditingController();
  int currentIndex = 0;

  List<Map<String, dynamic>> postDetailsList = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _fetchdata();
    print("User Email: ${AuthService.currentUser!.email}");
  }

  void _fetchdata() {
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

            postDetailsList.add(postMap);
          },
        );
        //print(postData);
        //return display(data: postData);
      }
    });
  }

  Future<Map<String, dynamic>> fetchSelectedPost() async {
    // Logic to fetch the details of the selected post asynchronously
    // For example, you might make a network request here
    // Replace this with your actual implementation
    await Future.delayed(Duration(seconds: 1)); // Simulating delay
    return {'author': 'Selected Author', 'content': 'Selected Content'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Lawbizcase'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.add_circle_outline_rounded),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  _to_post();
                });
                print('direct to postScreen');
              } //navgate to write post screen.
              ),
        ],
      ),
      body: <Widget>[
        //index0 home
        ListView.builder(
            itemCount: postDetailsList.length,
            itemBuilder: (context, index) {
              if (index < 0 || index >= postDetailsList.length) {
                // Debugging: Print the problematic index
                print('Invalid index: $index');
                // Return an empty container or placeholder widget
                return Container();
              }

              Map<String, dynamic> postDetail = postDetailsList[index];
              String time = postDetail['timestamp'].toString();
              String formattedTime =
                  time.length > 10 ? time.substring(0, time.length - 10) : time;
              return Card(
                //กล่อง
                child: ListTile(
                  title: Text(
                    //'${postDetail['author'].toString()} • $formattedTime',
                    postDetail['content'],
                    style: const TextStyle(fontSize: 20.0
                        //fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                      '${postDetail['agreeList'].length} agree • ${postDetail['author'].toString()} • $formattedTime'),
                  //Text(postDetail['content'],style: TextStyle(fontSize: 18.0),),

                  trailing: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      List<PopupMenuEntry<String>> items = [];

                      // if currentUser != post owner, they can only click Agree

                      //agree
                      items.add(
                        PopupMenuItem<String>(
                          value: 'Agree',
                          child: Text('Agree'),
                          // Empty onSelected handler
                          onTap: () {
                            String curUid = AuthService.currentUser!.uid;
                            if (!postDetail['agreeList'].contains(curUid)) {
                              dbRef
                                  .child('Post')
                                  .child(postDetail['postID'].toString())
                                  .child('agreeList')
                                  .update({
                                '${AuthService.currentUser!.uid}':
                                    AuthService.currentUser!.uid
                              }).then((_) {
                                setState(() {
                                  // Update the local state to reflect the changes
                                  //postDetail['agreeList'] =
                                  //  AuthService.currentUser!.uid;
                                  //print(postDetail['agreeList'][2]);
                                  //postDetail['agreeList'] = postDetailsList[index]['agreeList'];
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

                      // If the current user is owner of the post,
                      //beside Agree they can make it a case, edit, delete
                      if (AuthService.currentUser?.uid == postDetail['uid']) {
                        //make this post to case
                        items.add(
                          PopupMenuItem<String>(
                            value: 'Make this post to case',
                            child: Text('Make this post to case'),
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
                            child: Text('Edit'),
                            // Empty onSelected handler
                            onTap: () {},
                          ),
                        );
                        //delete post
                        items.add(
                          PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete'),
                            onTap: () {
                              print('tab delete');
                              dbRef
                                  .child('Post')
                                  .child(postDetail['postID'].toString())
                                  .remove()
                                  .then((_) {
                                // Remove the item from the local state
                                setState(() {
                                  postDetailsList.removeWhere((item) =>
                                      item['postID'] == postDetail['postID']);
                                });
                              }).catchError((e) {
                                print(e);
                              });
                              //_deleteDialog(postDetail['postID'].toString());
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
        //search index 1
        SearchAnchor(
            searchController: searrchController,
            builder: (BuildContext context, SearchController controller) {
              return IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            }),
        //profile index2
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Display user picture
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(AuthService.currentUser!.photoURL ?? ''),
                  radius: 50,
                ),
                SizedBox(height: 10),
                // Display user email
                Text(
                  AuthService.currentUser!.email ?? '',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () {
                      _to_regisL();
                    });
                    print('direct to regisL');
                  },
                  child: const Text(
                    'Register as Lawyer',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () {
                      _to_regisP();
                    });
                    print('direct to regisP');
                  },
                  child: Text('Register as PLaintiff'),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Log out'),
                )
              ],
            ),
          ),
        ),
      ][currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedIndex: currentIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.search_rounded), label: 'Search'),
          NavigationDestination(
              icon: Icon(Icons.person_rounded), label: 'Profile')
        ],
      ),
    );
  }

  Widget _to_regisP() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => regisP()),
    );
    return Container();
  }

  Widget _to_regisL() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => regisL()),
    );
    return Container();
  }

  Widget _to_post() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => postScreen()));
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
                dbRef.child('Post').child(key).remove();
              },
            ),
          ],
        );
      },
    );
  }
}
