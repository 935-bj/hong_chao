import 'package:flutter/material.dart';

class rateLawyer extends StatefulWidget {
  static String routeName = '/rateLawyer';
  
  const rateLawyer({Key? key}) : super(key: key);
  
  @override
  _rateLawyerState createState() => _rateLawyerState();
}

class _rateLawyerState extends State<rateLawyer> {
  int _stars = 0;

  Widget _buildStar(int starCount) {
    return IconButton(
      icon: Icon(
        _stars >= starCount ? Icons.star : Icons.star_border,
        color: Colors.orange,
      ),
      onPressed: () {
        setState(() {
          _stars = starCount;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('Rate Lawyer'),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStar(1),
          _buildStar(2),
          _buildStar(3),
          _buildStar(4),
          _buildStar(5),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_stars);
          },
        ),
      ],
    );
  }
}