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
  int _minimumBid = 0;

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('OpenCase').child('Bid');
    ref = FirebaseDatabase.instance.ref().child('OpenCase').child('Bid');
    _bidAmountController = TextEditingController();
    // _fetchAuthorInfo();

    // Listen to changes in the bid amount and update the minimum bid
    ref.child(widget.postDetail!['postID']).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? bids = snapshot.value as Map<dynamic, dynamic>?;
        if (bids != null) {
          int? minBid = bids.entries.fold<int?>(null, (prev, entry) {
            int bidAmount = int.tryParse(entry.value['Biding price']) ?? 0;
            if (prev == null) {
              return bidAmount;
            } else {
              return bidAmount < prev ? bidAmount : prev;
            }
          });
          _minimumBid = minBid != null ? minBid : 0;
          setState(() {});
        }
      }
    });
  }

  Future<void> _submitBid() async {
    try {
      User? user = AuthService.currentUser;
      String displayName = await getUsername();

      DateTime now = DateTime.now();
      String formattedTime = now.toUtc().toString();

      int bidAmount = int.tryParse(_bidAmountController.text) ?? 0;

      if (widget.postDetail != null) {
        var newBidRef = ref.child(widget.postDetail!['postID']).push();

        await newBidRef.set({
          'author': displayName,
          'Biding price': bidAmount.toString(),
          'timestamp': formattedTime,
        });

        setState(() {});
        _bidAmountController.clear();

        print('Bid placed successfully!');
      } else {
        print('Error: widget.postDetail is null');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<String> getUsername() async {
    try {
      String? snapshot = await AuthService().username();
      if (snapshot != null) {
        return snapshot;
      } else {
        return '';
      }
    } catch (e) {
      return 'getUsername() Error: $e';
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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lawyer: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  usernameWg(),
                  /*Text(
                    AuthService.currentUser!.email ?? '',
                    style: TextStyle(fontSize: 18),
                  ),*/
                ],
              ),
            ),
            Text(
              'Current Minimum Bid: $_minimumBid',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
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
                        title: Row(
                          children: [
                            Text(
                              'Lawyer: ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              AuthService.currentUser!.email ?? '',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
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
}

class Bidding {
  int _currentBid = 0;
  int _minimumIncrement = 5;

  void placeBid(int bidAmount) {
    if (bidAmount >= _currentBid + _minimumIncrement) {
      _currentBid = bidAmount;
      print('Bid of \$$_currentBid placed successfully.');
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
