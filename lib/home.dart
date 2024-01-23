import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hong_chao/regisP.dart';

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
              onPressed: () {} //navgate to write post screen.
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
                    Navigator.pushNamed(context, regisP.routeName);
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
}
