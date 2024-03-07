// Future<void> _submitCase() async {
//     try {
//       // Get current user UID and author
//       User? user = FirebaseAuth.instance.currentUser;
//       String? uid = user?.uid;
//       String? author = user?.displayName;

//       // Create a new case object with the current data
//       Map<String, dynamic> caseData = {
//         'startDate': _startDate.toString(),
//         'endDate': _endDate.toString(),
//         'uid': uid,
//         'author': author,
//       };

//       // Check if the switch is active
//       if (switchValue) {
//         // Retrieve the content from the Post child
//         var contentSnapshot = await dbRef
//             .child('Post')
//             .child(widget.postDetail!['postID'])
//             .child('content')
//             .once();

//         // Extract the value from the DataSnapshot
//         var content = contentSnapshot.snapshot.value;

//         // Update the OpenCase child with the retrieved content
//         await dbRef
//             .child('OpenCase')
//             .child(widget.postDetail!['postID'])
//             .update({
//           'startDate': _startDate.toString(),
//           'endDate': _endDate.toString(),
//           'status': 'Open',
//           'content': content, // Update content from Post to OpenCase
//         });
//         await dbRef.child('Post').child(widget.postDetail!['postID']).update({
//           'areCase': 'True',
//         });
//       // } else {
//       //   print('Switch is inactive');
//       //   // If switch is inactive, set the post status to 'closed' in the database
//       //   await dbRef
//       //       .child('OpenCase')
//       //       .child(widget.postDetail!['postID'])
//       //       .update({
//       //     'startDate': _startDate.toString(),
//       //     'endDate': _endDate.toString(),
//       //     'status': 'close',
//       //   });

//         await dbRef
//             .child('Post')
//             .child(widget.postDetail!['postID'])
//             .update({'areCase': 'False'});
//       }
//     } catch (error) {
//       print('Error submitting case: $error');
//     }
//   }




// @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     String _formattedTime(DateTime time) {
//       return DateFormat('dd-MM-yyyy HH:mm').format(now);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//             //child: Text('Open Case'),
//             ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Other widgets can go here...
//             Text(
//               _author ?? '', // Use the _author variable here
//               style: const TextStyle(fontSize: 18.0),
//             ),
//             const SizedBox(height: 16), // Add some spacing between widgets

//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: widget.postDetail == null
//                     ? const Center(child: CircularProgressIndicator())
//                     : Column(
//                         //crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.postDetail!['content'],
//                             style: const TextStyle(fontSize: 18.0),
//                           ),
//                         ],
//                       ),
//               ),
//             ),

//             const SizedBox(
//               height: 10,
//             ),

//             // Add the Switch widget
//             Row(
//               children: [
//                 const Text(
//                   'Open for case bidding',
//                   style: TextStyle(fontSize: 17.0),
//                 ),
//                 const Spacer(), // Add space to separate the label and the Switch
//                 Switch(
//                   value: switchValue,
//                   onChanged: (newValue) {
//                     setState(() {
//                       switchValue = newValue;
//                       // You can add logic here based on the switch value
//                     });
//                   },
//                   activeColor: Colors.green, // Change active color to green
//                   //inactiveThumbColor: Colors.green.shade100, // Change inactive color to a lighter green
//                 ),
//               ],
//             ),

//             const SizedBox(
//               height: 10,
//             ),

//             // Add the Select date widget
//             Row(children: [
//               ElevatedButton(
//                 onPressed: () => _selectDate(context, false),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(
//                       255, 250, 94, 94), // Set button color to red
//                 ),
//                 child: const Text(
//                   'End Date',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15.0 // Set text color to white
//                       ),
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                   '${_formattedDate(_startDate)} to ${_formattedDate(_endDate)}',
//                   style: const TextStyle(fontSize: 17.0)),
//             ]),

//             const SizedBox(
//               height: 50,
//             ),

//             //Submit button
//             ElevatedButton(
//               onPressed: () {
//                 _submitCase();
//                 Navigator.of(context).pop(); // Close the current page
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.lightBlue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: const Center(
//                   child: Text(
//                     'Submit',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }