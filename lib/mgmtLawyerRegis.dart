import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class mgmtLawyerRegis extends StatefulWidget {
  static String routeName = '/mgmtLawyerRegis';
  const mgmtLawyerRegis({super.key});

  @override
  State<mgmtLawyerRegis> createState() => _mgmtLawyerRegisState();
}

class _mgmtLawyerRegisState extends State<mgmtLawyerRegis> {
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
    dbRef.child('lawyer_form').onValue.listen((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> registrationData = snapshot.snapshot.value as Map;
        registrationData.forEach((key, value) {
          Map<dynamic, dynamic> registrationDetails = value as Map;

          bool isDuplicate =
              registrationList.any((element) => element['regisID'] == key);

          if (!isDuplicate) {
            Map<String, dynamic> registrationMap = {
              'regisID': key,
              'lid': registrationDetails['lid'],
              'lidUrl': registrationDetails['lidUrl'],
              'name': registrationDetails['name'],
              'nid': registrationDetails['nid'],
              'nidUrl': registrationDetails['nidUrl'],
              'phone': registrationDetails['phone'],
            };
            //print(registrationMap);
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
          child: Text('Manage Lawyer Registrations'),
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
                    'regisID: ${registrationDetail['regisID']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'LID: ${registrationDetail['lid']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Lawyer licence picture:',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                  content: Image.network(
                                registrationDetail['lidUrl'],
                              )));
                    },
                    child: Image.network(
                      registrationDetail[
                          'lidUrl'], // Provide the image URL here
                      width: 200, // Adjust width as needed
                      height: 200, // Adjust height as needed
                      fit: BoxFit.cover,
                      // Adjust the fit property as needed
                    ),
                  ),
                  Text(
                    'name: ${registrationDetail['name']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'nationalID: ${registrationDetail['nid']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'national ID picture:',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                  content: Image.network(
                                registrationDetail['nidUrl'],
                              )));
                    },
                    child: Image.network(
                      registrationDetail[
                          'nidUrl'], // Provide the image URL here
                      width: 200, // Adjust width as needed
                      height: 200, // Adjust height as needed
                      fit: BoxFit.cover,
                      // Adjust the fit property as needed
                    ),
                  ),
                  Text(
                    'phone: ${registrationDetail['phone']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // ลบข้อมูลในdatabase
                          dbRef
                              .child('lawyer_form')
                              .child(registrationDetail['regisID'].toString())
                              .remove()
                              .then((_) {
                            //ลบข้อมูลในUI
                            setState(() {
                              registrationList.removeWhere((registration) =>
                                  registration['regisID'] ==
                                  registrationDetail['regisID']);
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Decline',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(208, 72, 47, 1.0),
                        ),
                      ),
                      const SizedBox(width: 25),
                      ElevatedButton.icon(
                        onPressed: () {
                          // ลบข้อมูลในdatabase
                          dbRef
                              .child('lawyer_form')
                              .child(registrationDetail['regisID'].toString())
                              .remove()
                              .then((_) {
                            //ลบข้อมูลในUI
                            setState(() {
                              registrationList.removeWhere((registration) =>
                                  registration['regisID'] ==
                                  registrationDetail['regisID']);
                            });
                          });
                          dbRef
                              .child('user')
                              .child(registrationDetail['regisID'].toString())
                              .update({'type': 'L'});
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        label: const Text('Approve',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(132, 177, 40, 1.0)),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
