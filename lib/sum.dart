import 'package:flutter/material.dart';

class sum extends StatefulWidget {
  static String routeName = '/sum';
  const sum({super.key});

  @override
  State<sum> createState() => _sumState();
}

class _sumState extends State<sum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HongChao'),
      ),
    );
  }
}
