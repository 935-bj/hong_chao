import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hong_chao/home.dart';
import 'package:hong_chao/authService.dart';
import 'package:hong_chao/rateLawyer.dart';

import 'package:intl/intl.dart';

class JoinP extends StatefulWidget {
  static String routeName = '/JoinP';
  final Map<String, dynamic>? postDetail;

  const JoinP({Key? key, this.postDetail}) : super(key: key);

  @override
  _JoinPState createState() => _JoinPState();
}

class _JoinPState extends State<JoinP> {
  late DatabaseReference dbRef;
  late DatabaseReference ref;

  // void rateLawyer(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => rateLawyer(),
  //     ),
  //   );
  // }

  List<Map<String, dynamic>> bidsList = [];

  String? _uid;
  String? _author;

  Bidding _bidding = Bidding();
  late TextEditingController _bidAmountController;
  int _minimumBid = 0;

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('OpenCase');
    ref = dbRef.child(widget.postDetail!['postID']).child('Bids');
    _bidAmountController = TextEditingController();
    // _fetchAuthorInfo();

    // Listen to changes in the bid amount and update the minimum bid
    ref.onValue.listen((event) {
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

          if (minBid != null) {
            // Find the author who placed the minimum bid
            String? minBidAuthor;
            bids.forEach((key, value) {
              if (value['Biding price'] == minBid.toString()) {
                minBidAuthor = value['author'];
              }
            });

            // Update the minimum bid and author
            _minimumBid = minBid;
            _author = minBidAuthor;

            setState(() {});
          }
        }
      }
    });
  }

  Future<void> _submitBid() async {
    try {
      User? user = AuthService.currentUser;
      String displayName = await getUsername();

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('dd-MM-yyyy HH:mm').format(now);

      int bidAmount = int.tryParse(_bidAmountController.text) ?? 0;

      if (widget.postDetail != null) {
        var newBidRef = ref.push();

        await newBidRef.set({
          'author': displayName,
          'Biding price': bidAmount.toString(),
          'timestamp': formattedTime,
        });

        setState(() {});
        _bidAmountController.clear();

        // Display details of the latest bid
        var latestBid = {
          'author': displayName,
          'Biding price': bidAmount.toString(),
          'timestamp': formattedTime,
        };

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
                    'Plaintiff: $_author',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //usernameWg(),
                ],
              ),
            ),
            Text(
              'Current Minimum Bid: $_minimumBid ฿',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
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
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  if (snapshot.value != null && snapshot.value is Map) {
                    Map<dynamic, dynamic> bidMap =
                        snapshot.value as Map<dynamic, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              'Plaintiff: ${bidMap['author']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bid Amount: ${bidMap['Biding price']} ฿'),
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

      //       SizedBox(height: 20),
      // ElevatedButton(
      //         onPressed: () {
      //           _submitBid();
      //         },
      //         child: Text('Submit'),
      //       ),

    


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
      },
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