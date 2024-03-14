import 'package:flutter/material.dart';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:hong_chao/home.dart';
// import 'package:hong_chao/authService.dart';

// import 'package:intl/intl.dart';

// import 'package:rating_dialog/rating_dialog.dart';

//  final _dialog = RatingDialog(
//       initialRating: 1.0,
//       // your app's name?
//       title: Text(
//         'Rating Dialog',
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       // encourage your user to leave a high rating?
//       message: Text(
//         'Tap a star to set your rating. Add more description here if you want.',
//         textAlign: TextAlign.center,
//         style: const TextStyle(fontSize: 15),
//       ),
//       // your app's logo?
//       image: const FlutterLogo(size: 100),
//       submitButtonText: 'Submit',
//       commentHint: 'Set your custom comment hint',
//       onCancelled: () => print('cancelled'),
//       onSubmitted: (response) {
//         print('rating: ${response.rating}, comment: ${response.comment}');

//         // TODO: add your own logic
//         if (response.rating < 3.0) {
//           // send their comments to your email or anywhere you wish
//           // ask the user to contact you instead of leaving a bad review
//         } else {
//           _rateAndReviewApp();
//         }
//       },
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       barrierDismissible: true, // set to false if you want to force a rating
//       builder: (context) => _dialog,
//     );

