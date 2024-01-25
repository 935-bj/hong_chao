import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hong_chao/regisP.dart';
import 'package:hong_chao/post.dart';

import 'authService.dart';

class home extends StatefulWidget {
  static String routeName = '/home';
  final FirebaseAuth auth;
  final User? user;

  const home({Key? key, required this.auth, required this.user})
      : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late DatabaseReference dbRef;
  //controller
  final SearchController searrchController = SearchController();
  final TextEditingController postController = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print("User Email: ${widget.user?.email}");
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Write a Post'),
                        content: TextField(
                          controller: postController,
                          decoration: InputDecoration(
                              label: Text('your post content...')),
                        ),
                        actions: [
                          //close the dialog box
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('cancle'),
                          ),
                          //post
                          ElevatedButton(
                              onPressed: () {
                                var username;
                                DatabaseReference nameRef =
                                    FirebaseDatabase.instance.ref(
                                        'user/${AuthService.currentUser!.uid}/name');
                                nameRef.onValue.listen((DatabaseEvent event) {
                                  username = event.snapshot.value.toString();
                                });
                                //call post func.
                                post.createPost(dbRef, widget.user!.uid,
                                    username, postController.text, 'location');
                                postController.clear;
                                print(
                                    'post content: ${postController.text}, username: ${username}');
                                Navigator.of(context).pop();
                              },
                              child: Text('Post'))
                        ],
                      );
                    });
              } //navgate to write post screen.
              ),
        ],
      ),
      body: <Widget>[
        //home index 0
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text('Username'),
                  subtitle: Text('post content'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Username'),
                  subtitle: Text('post content'),
                ),
              ),
            ],
          ),
        ),
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
                  backgroundImage: NetworkImage(widget.user?.photoURL ?? ''),
                  radius: 50,
                ),
                SizedBox(height: 10),
                // Display user email
                Text(
                  widget.user?.email ?? '',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton(
                  onPressed: () {},
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
}
