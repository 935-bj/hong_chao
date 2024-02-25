import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hong_chao/home.dart';
import 'package:hong_chao/authService.dart';

import 'package:intl/intl.dart';

class BiddingScreen extends StatefulWidget {
  static String routeName = '/Biding';
  final Map<String, dynamic>? postDetail;

  const BiddingScreen({Key? key, this.postDetail}) : super(key: key);

  @override
  _BiddingScreenState createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  late DatabaseReference dbRef;
  late DatabaseReference ref;
  List<dynamic> dataList = [];
  String? _uid;
  String? _author;

  Bidding _bidding = Bidding();
  int _bidAmount = 0;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    ref = FirebaseDatabase.instance.ref().child('OpenCase').child('Bid');
    _fetchData();
  }

  Future<void> _fetchData() async {
    ref.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        setState(() {
          dataList = (snapshot.value as Map).values.toList();
        });
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  Future<void> _submitBid() async {
    try {
      // Get current user
      User? user = AuthService.currentUser;
      String? displayName = user?.displayName;

      // Get current time
      DateTime now = DateTime.now();
      String formattedTime = now.toUtc().toString();

      // Check if widget.postDetail is not null
      if (widget.postDetail != null) {
        // Create a new child node under 'Bid' using push()
        var newBidRef = ref.child(widget.postDetail!['postID']).push();

        // Update the new child node with the bid information
        await newBidRef.set({
          'author': displayName, // Add current user's display name
          'Biding price': _bidAmount.toString(), // Update with the bid amount
          'timestamp': formattedTime, // Add current time
        });
      } else {
        print('Error: widget.postDetail is null');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bidding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Current Bid: \$${_bidding.getCurrentBid()}'),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _bidAmount = int.tryParse(value) ?? 0;
              },
              decoration: InputDecoration(
                labelText: 'Enter Bid Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitBid();
              },
              child: Text('Place Bid'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  if (snapshot.value != null &&
                      snapshot.value is Map<dynamic, dynamic>) {
                    Map<dynamic, dynamic> dataMap =
                        snapshot.value as Map<dynamic, dynamic>;
                    List<dynamic> dataList = dataMap.values.toList();
                    // Ensure index is within bounds
                    return Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Biding price: ${dataList[index]['Biding price']}'),
                            Text('Time: ${dataList[index]['timestamp']}'),
                          ],
                        ),
                      ),
                    );
                  }
                  // If snapshot value is null or not a Map, or index is out of bounds, return an empty widget
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bidding {
  int _currentBid = 0;
  int _minimumIncrement = 5;

  void placeBid(int bidAmount) {
    if (bidAmount >= _currentBid + _minimumIncrement) {
      _currentBid = bidAmount;
      print('Bid of \$$_currentBid placed successfully.');
      // You might want to update the UI or perform other actions here.
    } else {
      print(
          'Bid amount must be at least \$${_currentBid + _minimumIncrement}.');
    }
  }

  int getCurrentBid() {
    return _currentBid;
  }

  void setMinimumIncrement(int increment) {
    if (increment > 0) {
      _minimumIncrement = increment;
      print('Minimum bid increment set to \$$_minimumIncrement.');
    } else {
      print('Minimum bid increment must be greater than 0.');
    }
  }
}