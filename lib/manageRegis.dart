
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class manageRegis extends StatefulWidget {
  static String routeName = '/manageRegis';
  const manageRegis({super.key});

  @override
  State<manageRegis> createState() => _manageRegisState();
}

class _manageRegisState extends State<manageRegis> {
  late DatabaseReference dbRef;
  List<Map<String, dynamic>> registrationList = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();

    _fetchdata();
  }

  void _fetchdata() {
    //reportDetailsList.clear();
    dbRef.child('registrations').onValue.listen((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> registrationData = snapshot.snapshot.value as Map;
        registrationData.forEach((key, value) {
          Map<dynamic, dynamic> registrationDetails = value as Map;

          bool isDuplicate =
               registrationList.any((element) => element['userID'] == key);

          if (!isDuplicate) {
            Map<String, dynamic> registrationMap = {
              'userID': key,
              'username': registrationDetails['username'],
              'email': registrationDetails['email'],
              'password': registrationDetails['password'],
              'birthdate': registrationDetails['birthdate'],
              'phoneNumber': registrationDetails['phoneNumber'],
            };
            print(registrationMap);
            setState(() {
              registrationList.add(registrationMap);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Manage Registrations'),
        ),
      ),
      body: ListView.builder(
          itemCount: registrationList.length,
          itemBuilder: (context, index) {
            if (index < 0 || index >= registrationList.length) {
              // Debugging: Print the problematic index
              print('Invalid index: $index');
              return Container();
            }

            Map<String, dynamic> registrationDetail = registrationList[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                  'User ID: ${registrationDetail['userID']}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Username: ${registrationDetail['username']}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Email: ${registrationDetail['email']}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Password: ${registrationDetail['password']}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Birth Date: ${registrationDetail['birthdate']}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Phone Number: ${registrationDetail['phoneNumber']}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ElevatedButton(
                      onPressed: () {
                        // Accept action
                      },
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Decline action
                      },
                      child: const Text('Decline'),
                    ),
                  ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}