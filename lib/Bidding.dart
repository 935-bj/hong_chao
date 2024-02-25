import 'package:flutter/material.dart';

class BiddingScreen extends StatefulWidget {
  @override
  _BiddingScreenState createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  Bidding _bidding = Bidding();
  int _bidAmount = 0;

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
                _bidding.placeBid(_bidAmount);
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
      print('Bid amount must be at least \$${_currentBid + _minimumIncrement}.');
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

void main() {
  runApp(MaterialApp(
    home: BiddingScreen(),
  ));
}