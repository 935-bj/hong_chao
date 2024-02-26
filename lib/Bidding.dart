import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
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

  List<Map<String, dynamic>> bidsList = [];

  String? _uid;
  String? _author;

  Bidding _bidding = Bidding();
  late TextEditingController _bidAmountController;

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('OpenCase').child('Bid');
    ref = FirebaseDatabase.instance.ref().child('OpenCase').child('Bid');
    _bidAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    super.dispose();
  }

  Future<void> _submitBid() async {
    try {
      // Get current user
      User? user = AuthService.currentUser;
      String? displayName = user?.displayName;

      // Get current time
      DateTime now = DateTime.now();
      String formattedTime = now.toUtc().toString();

      int bidAmount = int.tryParse(_bidAmountController.text) ?? 0;

      // Check if widget.postDetail is not null
      if (widget.postDetail != null) {
        // Create a new child node under 'Bid' using push()
        var newBidRef = ref.child(widget.postDetail!['postID']).push();

        // Update the new child node with the bid information
        await newBidRef.set({
          'author': displayName, // Add current user's display name
          'Biding price': bidAmount.toString(), // Update with the bid amount
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
            Text('Current Bid: \$${_bidding.getMinimumIncrement()}'),
            SizedBox(height: 20),
            TextFormField(
              controller: _bidAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Bid Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _submitBid();
                });
              },
              child: Text('Place Bid'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FirebaseAnimatedList(
                query: ref.child(widget.postDetail!['postID']),
                itemBuilder: (context, snapshot, animation, index) {
                  if (snapshot.value != null && snapshot.value is Map) {
                    Map<dynamic, dynamic> bidMap =
                        snapshot.value as Map<dynamic, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text('Author: ${bidMap['author']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bid Amount: ${bidMap['Biding price']}'),
                            Text('Timestamp: ${bidMap['timestamp']}'),
                          ],
                        ),
                      ),
                    );
                  }
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

  int getMinimumIncrement() {
    return _minimumIncrement;
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