import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import 'package:hong_chao/home.dart';

class OpenCase extends StatefulWidget {
  static String routeName = '/OpenCase';
  const OpenCase({super.key});

  @override
  State<OpenCase> createState() => _OpenCaseState();
}

class _OpenCaseState extends State<OpenCase> {
  late DatabaseReference dbRef;
  List<Map<String, dynamic>> postDetailsList = [];
  bool switchValue = false; // Add a boolean variable to control the Switch

  late DateTime _startDate;
  DateTime? _endDate;
  //late TimeOfDay _startTime;
  //late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _fetchdata();

    _startDate = DateTime.now();
    _endDate = DateTime.now(); // Initialize _endDate if necessary
    //_startTime = TimeOfDay.now(); // Initialize _startTime if necessary
    //_endTime = TimeOfDay.now(); // Initialize _endTime if necessary
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _fetchdata() {
    dbRef.child('Post').once().then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> postData = snapshot.snapshot.value as Map;
        postData.forEach(
          (key, value) {
            Map<dynamic, dynamic> postDetails = value as Map;

            Map<String, dynamic> postMap = {
              'postID': key,
              'author': postDetails['author'],
              'uid': postDetails['uid'],
              'content': postDetails['content'],
              'timestamp': postDetails['timestamp'],
            };

            postDetailsList.add(postMap);
          },
        );
        //print(postData);
        //return display(data: postData);
      }
    }).catchError((e) {
      print(e);
    });
  }

  String _formattedDate(DateTime? date) {
    return date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Not selected';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          //child: Text('Open Case'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Other widgets can go here...
            Text(
              'Posts Detail:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16), // Add some spacing between widgets

            // ListView.builder to display posts
            Expanded(
              child: postDetailsList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: postDetailsList.length,
                      itemBuilder: (context, index) {
                        // Build your UI based on the fetched data
                        // Example: display each post in a ListTile
                        return ListTile(
                          title: Text(postDetailsList[index]['author']),
                          subtitle: Text(postDetailsList[index]['content']),
                          // Add more details as needed
                        );
                      },
                    ),
            ),

            // Add the Switch widget
            Row(
              children: [
                Text(
                  'Open for case bidding',
                  style: TextStyle(fontSize: 17.0),
                ),
                Spacer(), // Add space to separate the label and the Switch
                Switch(
                  value: switchValue,
                  onChanged: (newValue) {
                    setState(() {
                      switchValue = newValue;
                      // You can add logic here based on the switch value
                    });
                  },
                  activeColor: Colors.green, // Change active color to green
                  //inactiveThumbColor: Colors.green.shade100, // Change inactive color to a lighter green
                ),
              ],
            ),

            // // Add the Select date widget
            // Row(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () => _selectDate(context, true),
            //       child: Text('Start Date'),
            //     ),
            //     //Text('Selected Start Date: ${_formattedDate(_startDate)}'),
            //     Text('Selected: ${_formattedDate(_startDate)}'),
            //   ],
            // ),

            // // Add the Select date widget
            // Row(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () => _selectDate(context, false),
            //       child: Text('End Date'),
            //     ),
            //     Text('Selected: ${_formattedDate(_endDate)}'),
            //   ],
            // ),

            //Text('Bidding period'),

            SizedBox(
              height: 10,
            ),

            // Add the Select date widget
            Row(children: [
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 250, 94, 94), // Set button color to red
                ),
                child: Text(
                  'End Date',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0 // Set text color to white
                      ),
                ),
              ),
              Spacer(),
              Text(
                  '${_formattedDate(_startDate)} to ${_formattedDate(_endDate)}',
                  style: TextStyle(fontSize: 17.0)),
            ]),

            SizedBox(
              height: 50,
            ),

            //Submit button
            ElevatedButton(
              onPressed: () {
                // Add the submit logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.lightBlue, // Set button color to light blue
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      5.0), // Adjust the borderRadius as needed
                ),
              ),
              child: Container(
                width:
                    double.infinity, // Make the button fill the available width
                padding: EdgeInsets.symmetric(
                    vertical: 15.0), // Adjust the padding as needed
                child: Center(
                  child: Text(
                    'Open Case',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}