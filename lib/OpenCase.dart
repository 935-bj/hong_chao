import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hong_chao/authService.dart';
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

  late DateTime _startDate;
  DateTime? _endDate;
  String? _uid;
  String? _author;

  String _formattedDate(DateTime? date) {
    return date != null
        ? DateFormat('dd-MM-yyyy HH:mm').format(date)
        : 'Not selected';
  }

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _fetchdata();

    _startDate = DateTime.now();
    _endDate = DateTime.now();
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
          // Resetting the time part to 00:00
          _endDate =
              DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
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

  Future<void> _openCase() async {
    try {
      // Get current user UID and author
      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      String? author = user?.displayName;

      // Format dates
      String startDateFormatted =
          DateFormat('dd-MM-yyyy HH:mm').format(_startDate);
      String endDateFormatted =
          DateFormat('dd-MM-yyyy HH:mm').format(_endDate!);

      // Get the username
      String username = await getUsername();

      // Create a new case object with the formatted dates and username
      Map<String, dynamic> caseData = {
        'startDate': startDateFormatted,
        'endDate': endDateFormatted,
        'uid': uid,
        'author': author,
        'username': username,
      };

      // Retrieve the content from the Post child
      var contentSnapshot = await dbRef
          .child('Post')
          .child(widget.postDetail!['postID'])
          .child('content')
          .once();

      // Extract the value from the DataSnapshot
      var content = contentSnapshot.snapshot.value;

      // Update the OpenCase child with the retrieved content and formatted dates
      await dbRef.child('OpenCase').child(widget.postDetail!['postID']).update({
        'startDate': startDateFormatted,
        'endDate': endDateFormatted,
        'author': username,
        'content': content, // Update content from Post to OpenCase
      });
      await dbRef.child('Post').child(widget.postDetail!['postID']).update({
        'areCase': 'True',
      });

      // Close the current page
      Navigator.of(context).pop();
    } catch (error) {
      print('Error opening case: $error');
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

  // Other methods remain unchanged

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String _formattedTime(DateTime time) {
      return DateFormat('dd-MM-yyyy HH:mm').format(now);
    }

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
              width: double.infinity, // Set width to fill the screen
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.postDetail == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.postDetail!['content'],
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                ),
              ),
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
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 17.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Start Date: ${_formattedDate(_startDate)}\n',
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'End Date: ${_formattedDate(_endDate)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 10),

            // Button to Open the case
            ElevatedButton(
              onPressed: _openCase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set button color to green
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: const Center(
                  child: Text(
                    'Open',
                    style: TextStyle(
                      color: Colors.white,
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