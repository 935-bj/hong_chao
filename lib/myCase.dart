import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hong_chao/Bidding.dart';
import 'package:hong_chao/authService.dart';
import 'package:intl/intl.dart';
import 'package:hong_chao/updateP.dart';

class myCase extends StatefulWidget {
  static String routeName = '/myCase';
  const myCase({super.key});

  @override
  State<myCase> createState() => _myCaseState();
}

class _myCaseState extends State<myCase> {
  late DatabaseReference dbRef;
  List<Map<String, dynamic>> postDetailsList = [];
  final String myUid = AuthService.currentUser!.uid;
  late String myUser;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('OpenCase');
    _fetchData();
    username();
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

  Future<String?> isUserNameMatched() async {
    AuthService authService = AuthService();
    return await authService.username();
  }

  Future<String?> isUserType() async {
    AuthService authService = AuthService(); // Instantiate AuthService
    return await authService.userType(); // Call userType() on the instance
  }

  void username() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('user')
        .child(AuthService.currentUser!.uid)
        .child('name');
    try {
      if (AuthService.currentUser!.uid != null) {
        final snapshot = await userRef.get();
        if (snapshot.exists) {
          //print('AuthService: name- ${snapshot.value}');
          myUser = snapshot.value.toString();
        } else {
          print('นี่คือเสียงจาก AuthService - no username data');
        }
      }
    } catch (e) {
      print("authService username Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance.ref('OpenCase'),
              itemBuilder: (context, snapshot, animation, index) {
                print('$myUser');
                print('${snapshot.child('author').value.toString()}');
                if (myUser == snapshot.child('author').value.toString() ||
                    snapshot.child('jointPt').hasChild(myUid)) {
                  DateTime endDate = DateFormat('dd-MM-yyyy HH:mm')
                      .parse(snapshot.child('endDate').value.toString());

                  // Check if current date is after endDate
                  bool isBeforeEndDate = DateTime.now().isBefore(endDate);

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
                                    return Text('Error: ${snapshot.error}');
                                  }
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
                } else {
                  return const SizedBox(
                    height: 0.1,
                  );
                }
              },
            ),
          ),
          // Other widgets can go here if needed
        ],
      ),
    );
  }
}
