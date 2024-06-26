import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/Bidding.dart';
import 'package:hong_chao/editPost.dart';
import 'package:hong_chao/login.dart';
import 'package:hong_chao/myPost.dart';
import 'package:hong_chao/myCase.dart';
import 'package:hong_chao/notiScreen.dart';
import 'package:hong_chao/postScreen.dart';
import 'package:hong_chao/regisL.dart';
import 'package:hong_chao/regisP.dart';
import 'package:hong_chao/OpenCase.dart';
import 'package:hong_chao/report.dart';
import 'package:hong_chao/joinPaintiff.dart';
import 'package:hong_chao/rateLawyer.dart';
import 'package:hong_chao/searchResult.dart';
import 'package:hong_chao/updateP.dart';
import 'package:intl/intl.dart';

import 'authService.dart';

class home extends StatefulWidget {
  static String routeName = '/home';
  const home({super.key});

  //get sentPid => _sentPid;

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late DatabaseReference dbRef;

  //controller
  final TextEditingController searchController = TextEditingController();
  final TextEditingController postController = TextEditingController();

  final auth = FirebaseAuth.instance; //consider to delete the unuse var
  final ref = FirebaseDatabase.instance.ref('OpenCase');
  //final notiRef = FirebaseDatabase.instance.ref('OpenCase').child('');

  //final mbref = FirebaseDatabase.instance.ref('OpenCase').child(postID!)..child('Bids');

  int currentIndex = 0;

  List<Map<String, dynamic>> postDetailsList = [];
  List<Map<String, dynamic>> notiDetailsList = [];

  // Assume postsList contains all posts fetched from the database
  List<Map<String, dynamic>> postsList = [];

  bool shouldDisplayJoinButton(DateTime endDate) {
    DateTime currentDate = DateTime.now();
    return currentDate
        .isBefore(endDate); // Returns true if current date is after endDate
  }

  String? _author;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _fetchdata();
    _fetchNoti();
    _checkUser();
    print("UserID: ${AuthService.currentUser!.uid}");
  }

  void _fetchdata() {
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
              postDetailsList.add(postMap);
            });
          },
        );
        //print(postData);
        //return display(data: postData);
      }
    });
  }

  void _fetchNoti() {
    notiDetailsList.clear();
    dbRef
        .child('noti')
        .child(AuthService.currentUser!.uid.toString())
        .onValue
        .listen((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> notiData = snapshot.snapshot.value as Map;
        notiData.forEach((key, value) {
          Map<dynamic, dynamic> notiDetails = value as Map;

          Map<String, dynamic> notiMap = {
            'time': key,
            'detail': notiDetails['detail'],
            'title': notiDetails['title'],
            'from': notiDetails['from']
          };
          setState(() {
            notiDetailsList.add(notiMap);
          });
        });
      }
    }, onError: (error) {
      print("Error fetching data: $error");
    });
  }

  Future<String?> isUserType() async {
    AuthService authService = AuthService(); // Instantiate AuthService
    return await authService.userType(); // Call userType() on the instance
  }

  Future<String?> isUserNameMatched() async {
    AuthService authService = AuthService();
    return await authService.username();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Lawbizcase'),
        ),
        //automaticallyImplyLeading: false,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
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
                              print('current user already agree to this post');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'You agree to this post already!',
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

                            /*Navigator.of(context).pushNamed(
                              report.routeName,
                              arguments: {'postID': postDetail['postID']},
                            ); */

                            /*Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    report(postID: postDetail['postID'])));
*/
                            //_to_report(postDetail['postID']);
                          },
                        ),
                      );

                      // If the current user is owner of the post,
                      //beside Agree they can make it a case, edit, delete
                      if (AuthService.currentUser?.uid == postDetail['uid']) {
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
                        isUserType().then((value) {
                          if (value == 'P') {
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
                          }
                        });
                      }

                      return items;
                    },
                  ),
                ),
              );
            }),

        //case index1
        Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  // display it in ListTile along with snapshot data

                  // Retrieve endDate from the snapshot
                  DateTime endDate = DateFormat('dd-MM-yyyy HH:mm')
                      .parse(snapshot.child('endDate').value.toString());

                  // Check if current date is after endDate
                  bool isBeforeEndDate = DateTime.now().isBefore(endDate);

                  // Access the necessary data fields from the snapshot
                  var postID = snapshot.key;

                  String? winningLawyerUsername = snapshot
                      .child('minBids')
                      .child('minimunBids')
                      .child('author')
                      .value as String?;

                  String? author = snapshot.child('author').value as String?;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 2, // adjust elevation as needed
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isBeforeEndDate)
                                    Text('Author: ' +
                                        snapshot
                                            .child('author')
                                            .value
                                            .toString()),
                                  if (!isBeforeEndDate)
                                    Text(
                                      'Due: ' +
                                          snapshot
                                              .child('endDate')
                                              .value
                                              .toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  SizedBox(height: 5),
                                  if (!isBeforeEndDate)
                                    Text(
                                      'Winning lawyer: ' +
                                          snapshot
                                              .child('minBids')
                                              .child('minimunBids')
                                              .child('author')
                                              .value
                                              .toString(),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 30, 255)),
                                    ),
                                  if (!isBeforeEndDate)
                                    Text(
                                      'Bidding price: ' +
                                          snapshot
                                              .child('minBids')
                                              .child('minimunBids')
                                              .child('Biding price')
                                              .value
                                              .toString(),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 0, 30, 255)),
                                    ),
                                  SizedBox(height: 10),
                                  if (isBeforeEndDate)
                                    Text('Author: ' +
                                        snapshot
                                            .child('author')
                                            .value
                                            .toString()),
                                  if (isBeforeEndDate)
                                    Text('Due: ' +
                                        snapshot
                                            .child('endDate')
                                            .value
                                            .toString()),
                                  SizedBox(height: 10),
                                  if (isBeforeEndDate)
                                    Text(
                                      'Current bidding price: ' +
                                          snapshot
                                              .child('minBids')
                                              .child('minimunBids')
                                              .child('Biding price')
                                              .value
                                              .toString(),
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  SizedBox(height: 5),
                                ],
                              ),
                              subtitle: Text(
                                snapshot.child('content').value.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: FutureBuilder<String?>(
                                future: isUserNameMatched(), // Pass postID here
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    // If an error occurred
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  //bool isUserNameMatching = snapshot.data ?? false; // Check if username matches
                                  if (snapshot.hasData) {
                                    String? currentUserName = snapshot.data;
                                    if (author == currentUserName) {
                                      return PopupMenuButton<String>(
                                        onSelected: (String choice) {
                                          if (choice == 'Delete') {
                                            // Delete functionality
                                            dbRef
                                                .child('OpenCase')
                                                .child(
                                                    postID!) // Use postID directly here
                                                .remove()
                                                .then((_) {
                                              // Remove the item from the local state
                                              setState(() {
                                                postDetailsList.removeWhere(
                                                    (item) =>
                                                        item['postID'] ==
                                                        postID);
                                              });
                                            }).catchError((e) {
                                              print(e);
                                            });
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return ['Delete']
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                            );
                                          }).toList();
                                        },
                                      );
                                    }
                                  }
                                  // If the username matches, you might return something else or null
                                  return SizedBox(); // Return an empty SizedBox if the username matches
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Display the Bidding button only if isBeforeEndDate is true
                                if (!isBeforeEndDate)
                                  FutureBuilder<String?>(
                                    future: isUserNameMatched(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        String? currentUserName = snapshot.data;
                                        if (winningLawyerUsername ==
                                            currentUserName) {
                                          return ElevatedButton(
                                            onPressed: () {
                                              if (postID != null) {
                                                var postDetail = {
                                                  'postID': postID
                                                };
                                                UpdateDialog.showUpdateDialog(
                                                    context, postDetail);
                                              } else {
                                                print(
                                                    'Error: Unable to get post detail.');
                                              }
                                            },
                                            child: Text('Update process'),
                                          );
                                        } else {
                                          return SizedBox(); // Or any other widget you want to show
                                        }
                                      }
                                      // This case handles the loading state, but returns nothing
                                      return SizedBox(); // Or any other widget you want to show
                                    },
                                  ),

                                if (isBeforeEndDate)
                                  Column(
                                    children: [
                                      FutureBuilder<String?>(
                                        future: isUserType(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          if (snapshot.hasData) {
                                            if (snapshot.data == 'L') {
                                              return ElevatedButton(
                                                onPressed: () async {
                                                  // Ensure postID is not null
                                                  if (postID != null) {
                                                    // Navigate to the BiddingScreen with postDetail
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BiddingScreen(
                                                          postDetail: {
                                                            'postID': postID
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    print(
                                                        'Error: postID is null.');
                                                  }
                                                },
                                                child: Text('Bidding'),
                                              );
                                            } else {
                                              // User's type is not 'L', they might be allowed to bid or join
                                              if (snapshot.data == 'P') {
                                                return ElevatedButton(
                                                  onPressed: () async {
                                                    // Ensure postID is not null
                                                    if (postID != null) {
                                                      try {
                                                        // Perform database operation to join as plaintiff
                                                        await dbRef
                                                            .child('OpenCase')
                                                            .child(postID!)
                                                            .child('jointPt')
                                                            .push()
                                                            .set(AuthService
                                                                .currentUser!
                                                                .uid);
                                                        print(
                                                            'Successfully joined as plaintiff');
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Successfully joined as plaintiff',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18)),
                                                            duration: Duration(
                                                                seconds: 5),
                                                          ),
                                                        );
                                                      } catch (e) {
                                                        print('Error: $e');
                                                      }
                                                    } else {
                                                      print(
                                                          'Error: postID is null.');
                                                    }
                                                    setState(() {});
                                                  },
                                                  child:
                                                      Text('Join as Plaintiff'),
                                                );
                                              } else {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      'You are not allowed to bid or join the case,',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight: FontWeight
                                                            .bold, // Set the color to red
                                                      ),
                                                    ),
                                                    Text(
                                                      'please change your user type',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .red, // Set the color to red
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }
                                          } else {
                                            // Data not available, handle this case accordingly
                                            return Text(
                                                'User data not available');
                                          }
                                        },
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Other widgets can go here if needed
          ],
        ),

        //search index 2
        search(searchController),

        //noti index3
        Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  var postID = snapshot.key;

                  String? joinPt = snapshot.child('jointPt').value?.toString();

                  if (joinPt != null) {
                    Map<dynamic, dynamic>? joinPtMap =
                        snapshot.child('jointPt').value as Map?;
                    if (joinPtMap != null) {
                      List<Widget> cards = [];
                      joinPtMap.forEach((key, value) {
                        if (value == AuthService.currentUser?.uid) {
                          // Access the noti node for the current notification
                          var notiSnapshot = snapshot.child('noti');
                          // Check if notiSnapshot exists and contains data
                          if (notiSnapshot.exists) {
                            // Iterate over each child of notiSnapshot (each notification)
                            notiSnapshot.children
                                .forEach((notificationSnapshot) {
                              // Access the time for the current notification
                              var time = notificationSnapshot
                                  .child('time')
                                  .value
                                  .toString();
                              // Add a Card to the list of cards
                              cards.add(
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Time: $time',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Your case has been updated!',
                                            style: TextStyle(
                                              color: Colors
                                                  .red, // Change color to red
                                              fontSize:
                                                  18, // Increase font size for prominence
                                              fontWeight: FontWeight
                                                  .bold, // Emphasize the status
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (snapshot.value != null) {
                                                    var postDetail = {
                                                      'postID': postID
                                                    };
                                                    UpdateDialog.showNotiDialog(
                                                        context,
                                                        postDetail,
                                                        snapshot);
                                                  } else {
                                                    print(
                                                        'Error: Unable to get post detail.');
                                                  }
                                                },
                                                child: Text('Check status'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          }
                        }
                      });
                      return Column(
                        children: cards,
                      );
                    }
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),

        //noti(),

        //profile index4
        customProfile(),
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
            icon: Icon(Icons.star_rounded),
            label: 'case',
          ),
          NavigationDestination(
              icon: Icon(Icons.search_rounded), label: 'Search'),
          NavigationDestination(
              icon: Icon(Icons.notifications_rounded), label: 'Noti'),
          NavigationDestination(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _to_regisP() {
    Navigator.pushNamed(context, regisP.routeName);
    return Container();
  }

  Widget _to_regisL() {
    Navigator.pushNamed(context, regisL.routeName);
    return Container();
  }

  Widget _to_post() {
    Navigator.pushNamed(context, postScreen.routeName);
    return Container();
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

  void _checkUser() {
    List<String> uid = [];
    final TextEditingController _nameController = TextEditingController();

    dbRef.child('user').once().then((DatabaseEvent? snapshot) {
      Map<dynamic, dynamic> userdata = snapshot?.snapshot.value as Map;
      userdata.forEach((key, value) {
        uid.add(key);
      });

      if (!uid.contains(AuthService.currentUser!.uid)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text('To complete the registration please set the username'),
              content: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Enter your username'),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('create account'),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      if (_nameController.text.length >= 5) {
                        if (_nameController.text
                            .contains(RegExp(r'[a-zA-Z]'))) {
                          dbRef
                              .child('user')
                              .child(AuthService.currentUser!.uid.toString())
                              .set({
                            'mail': AuthService.currentUser?.email,
                            'name': _nameController.text,
                            'type': 'N',
                          });
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  Widget usernameWg() {
    return FutureBuilder<String?>(
        future: AuthService().username(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display loading indicator while waiting
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text(
                snapshot.data ?? '',
                style: const TextStyle(fontSize: 20),
              );
            }
          }
        });
  }

  Widget customProfile() {
    return FutureBuilder<String?>(
        future: AuthService().userType(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display loading indicator while waiting
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data == 'N') {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Display user picture
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              AuthService.currentUser!.photoURL ?? ''),
                          radius: 50,
                        ),
                        const SizedBox(height: 10),
                        // Display username
                        usernameWg(),
                        /*Text(
                          authService().username().toString(),
                          style: const TextStyle(fontSize: 20),
                        ),*/
                        const SizedBox(
                          width: 20,
                        ),
                        Text('Normal User'),
                        const SizedBox(
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
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Future.delayed(Duration.zero, () {
                              _to_regisP();
                            });
                            print('direct to regisP');
                          },
                          child: const Text('Register as Plaintiff'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, myPost.routeName);
                          },
                          child: const Text('My post'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            AuthService().signOut(context);
                            print('log out');
                            /**Navigator.pushReplacementNamed(
                                context, login.routeName);**/
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => login()),
                            );
                            //try .pop()
                          },
                          child: const Text('Log out'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                if (snapshot.data == 'P') {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Display user picture
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                AuthService.currentUser!.photoURL ?? ''),
                            radius: 50,
                          ),
                          const SizedBox(height: 10),
                          // Display user email
                          usernameWg(),
                          const SizedBox(
                            width: 20,
                          ),
                          Text('Plaintiff User'),
                          const SizedBox(
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
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, myPost.routeName);
                            },
                            child: const Text('My post'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              AuthService().signOut(context);
                              print('log out');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login()),
                              );
                            },
                            child: const Text('Log out'),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  //snapshot.data == 'L'
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Display user picture
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                AuthService.currentUser!.photoURL ?? ''),
                            radius: 50,
                          ),
                          const SizedBox(height: 10),
                          // Display user email
                          usernameWg(),
                          const SizedBox(
                            width: 20,
                          ),
                          Text('Lawyer User'),
                          const SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                _to_regisP();
                              });
                              print('direct to regisP');
                            },
                            child: const Text('Register as Plaintiff'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, myPost.routeName);
                            },
                            child: const Text('My post'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              AuthService().signOut(context);
                              print('log out');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login()),
                              );
                            },
                            child: const Text('Log out'),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }
            }
          }
        });
  }

  Widget search(TextEditingController searchController) {
    String searchQ = '';
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8.0), // Adjust margin as needed
                child: TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepPurple,
              child: IconButton(
                icon: const Icon(Icons.search_rounded),
                color: Colors.white,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  searchQ = searchController.text.toLowerCase();
                  searchController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => searchResult(searchQ: searchQ),
                    ),
                  );
                  //searchResult(searchQ);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget noti() {
    //sord notiDetailsList
    notiDetailsList.sort((a, b) => (b['time']).compareTo(a['time']));
    return ListView.builder(
        itemCount: notiDetailsList.length,
        itemBuilder: (context, index) {
          if (index < 0 || index >= postDetailsList.length) {
            // Debugging: Print the problematic index
            print('Invalid index: $index');
            return Container();
          }
          Map<String, dynamic> notiDetail = notiDetailsList[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => notiScreen(
                            caseID: notiDetail['from'] ?? 'no data ',
                            timestamp: '',
                          )),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(
                    notiDetail['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    notiDetail['detail'] ?? '',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ));
        });
  }
}
