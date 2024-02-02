import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class OpenCase extends StatefulWidget {
  static String routeName = '/OpenCase';

  final Map<String, dynamic>? postDetail;
  const OpenCase({Key? key, required this.postDetail}) : super(key: key);

  @override
  State<OpenCase> createState() => _OpenCaseState();
}

class _OpenCaseState extends State<OpenCase> {
  late DatabaseReference dbRef;
  List<Map<String, dynamic>> postDetailsList = [];
  bool switchValue = false; // Add a boolean variable to control the Switch

  late DateTime _startDate;
  DateTime? _endDate;
  String? _uid;
  String? _author;

  String _formattedDate(DateTime? date) {
    return date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Not selected';
  }

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
      initialDate: isStartDate ? _startDate : _endDate ?? DateTime.now(),
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

  Future<void> _fetchdata() async {
    await dbRef
        .child('Post')
        .child(widget.postDetail!['postID'])
        .once()
        .then((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> postDetails = snapshot.snapshot.value as Map;

        // Get UID and author from the current post
        _uid = postDetails['uid'];
        _author = postDetails['author'];

        // Update start time, end time, UID, and author
        setState(() {
          _startDate = DateTime.now(); // Update with your logic
          _endDate = DateTime.now(); // Update with your logic
          // Update other values as needed
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _submitCase() async {
    try {
      // Get current user UID and author
      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      String? author = user?.displayName;

      // Create a new case object with the current data
      Map<String, dynamic> caseData = {
        'startDate': _startDate.toString(),
        'endDate': _endDate.toString(),
        'uid': uid,
        'author': author,
      };

      // Check if the switch is active
      if (switchValue) {
        await dbRef
            .child('OpenCase')
            .child(widget.postDetail!['postID'])
            .update({
          'startDate': _startDate.toString(),
          'endDate': _endDate.toString(),
          'status': 'Open',
        });

        await dbRef.child('Post').child(widget.postDetail!['postID']).update({'areCase':'True'});

        
      } else {
        print('Switch is inactive');
        // If switch is inactive, set the post status to 'closed' in the database
        await dbRef
            .child('OpenCase')
            .child(widget.postDetail!['postID'])
            .update({
          'startDate': _startDate.toString(),
          'endDate': _endDate.toString(),
          'status': 'closed',
        });

        await dbRef.child('Post').child(widget.postDetail!['postID']).update({'areCase':'False'});
      }
    } catch (error) {
      print('Error submitting case: $error');
    }
  }

  // Other methods remain unchanged

  @override
  Widget build(BuildContext context) {
    String formattedTime = '';
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
              _author ?? '', // Use the _author variable here
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16), // Add some spacing between widgets

            Container(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 215, 215, 215), // Specify the color you want
                borderRadius: BorderRadius.circular(
                    10.0), // Adjust the borderRadius as needed
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: widget.postDetail == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.postDetail!['content'],
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
              ),
            ),

            // Add the Switch widget
            Row(
              children: [
                const Text(
                  'Open for case bidding',
                  style: TextStyle(fontSize: 17.0),
                ),
                const Spacer(), // Add space to separate the label and the Switch
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

            const SizedBox(
              height: 10,
            ),

            // Add the Select date widget
            Row(children: [
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 250, 94, 94), // Set button color to red
                ),
                child: const Text(
                  'End Date',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0 // Set text color to white
                      ),
                ),
              ),
              const Spacer(),
              Text(
                  '${_formattedDate(_startDate)} to ${_formattedDate(_endDate)}',
                  style: const TextStyle(fontSize: 17.0)),
            ]),

            const SizedBox(
              height: 50,
            ),

            //Submit button
            ElevatedButton(
              onPressed: _submitCase, // Call _submitCase when button is pressed
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
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0), // Adjust the padding as needed
                child: const Center(
                  child: Text(
                    'Submit',
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
