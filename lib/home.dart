import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hong_chao/postScreen.dart';
import 'package:hong_chao/regisL.dart';
import 'package:hong_chao/regisP.dart';

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
    dbRef.child('Post').once().then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> postData = snapshot.snapshot.value as Map;
        postData.forEach(
          (key, value) {
            Map<dynamic, dynamic> postDetails = value as Map;

            Map<String, dynamic> postMap = {
              'postID': key,
              'author': postDetails['author'],
              'uid': postDetails['uid'],
              'content': postDetails['content'],
              'timestamp': postDetails['timestamp'],
            };

            postDetailsList.add(postMap);
          },
        );
        //print(postData);
        //return display(data: postData);
      }
    }).catchError((e) {
      print(e);
    });
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
        ListView.builder(
            itemCount: postDetailsList.length,
            itemBuilder: (context, index) {
              if (index < 0 || index >= postDetailsList.length) {
                // Handle the case where the index is out of bounds
                return SizedBox.shrink(); // or any other fallback widget
              }

              Map<String, dynamic> postDetail = postDetailsList[index];
              String time = postDetail['timestamp'].toString();
              return Card(
                child: ListTile(
                  title: Text(
                      '${postDetail['author'].toString()} • ${time.substring(0, time.length - 10)}'),
                  subtitle: Text(postDetail['content']),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String choice) {
                      print('Selected: $choice');
                    },
                    itemBuilder: (BuildContext context) {
                      if (AuthService.currentUser?.uid == postDetail['uid']) {
                        return <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Make this post to case',
                            child: Text('Make this post to case'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete'),
                          )
                        ];
                      } else {
                        return <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Agree',
                            child: Text('Agree'),
                          ),
                        ];
                      }
                    },
                  ),
                ),
              );
            }),
        //scarch index 1
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
}
