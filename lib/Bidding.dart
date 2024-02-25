import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hong_chao/home.dart';

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
  String? _uid;
  String? _author;

  Bidding _bidding = Bidding();
  int _bidAmount = 0;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> _fetchdata() async {
    await dbRef.child('Post').once().then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> postDetails = snapshot.snapshot.value as Map;

        // Get UID and author from the current post
        _uid = postDetails['uid'];
        _author = postDetails['author'];
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _submitBid() async {
    try {
      // Get current user UID and author
      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      String? author = user?.displayName;
      // Check if widget.postDetail is not null
      if (widget.postDetail != null) {
        // Retrieve the content from the Post child
        var contentSnapshot = await dbRef
            .child('Post')
            .child(widget.postDetail!['postID'])
            .child('content')
            .once();
        // Update the OpenCase child with the retrieved content
        await dbRef
            .child('OpenCase')
            .child(widget.postDetail!['postID'])
            .child('Bid')
            .update({
          'Biding price': _bidAmount.toString(), // Update with the bid amount
        });
        await dbRef.child('Post').child(widget.postDetail!['postID']).update({
          'areCase': 'True',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Bid: \$${_bidding.getCurrentBid()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitBid();
              },
              child: Text('Place Bid'),
            ),
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