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

  List<String> dataFromFirebase = [];

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
        Map/*<dynamic, dynamic>*/ postData = snapshot.snapshot.value as Map;
        postData.forEach(
          (key, value) {
            setState(() {
              dataFromFirebase.add(value.toString());
            });
          },
        );
        print(postData);
        //return display(data: postData);
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
        //home index 0
        /*const Padding(
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
        ), */
        ListView.builder(
            itemCount: dataFromFirebase.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(dataFromFirebase[index]),
                  // Add more ListTile properties or customize Card content here
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
