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
              'licence': registrationDetails['lid'],
              'licenceUrl': registrationDetails['lidUrl'],
              'name': registrationDetails['name'],
              'nationalID': registrationDetails['nid'],
              'nationalIDUrl': registrationDetails['nidUrl'],
              'phone': registrationDetails['phone'],
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
                    'licence: ${registrationDetail['lid']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'licenceUrl: ${registrationDetail['lidUrl']}',
                    style: const TextStyle(fontSize: 18.0),
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
                    'nationalIDUrl: ${registrationDetail['nidUrl']}',
                    style: const TextStyle(fontSize: 18.0),
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
                          //delete post
                          // dbRef
                          //     .child('Post')
                          //     .child(reportDetail['postID'].toString())
                          //     .remove();
                          // //delete report
                          // dbRef
                          //     .child('reportPost')
                          //     .child(reportDetail['reportID'].toString())
                          //     .remove()
                          //     .then((_) {
                          //   setState(() {
                          //     reportDetailsList.removeWhere((report) =>
                          //         report['reportID'] ==
                          //         reportDetail['reportID']);
                          //   });
                          // });
                        },
                        icon: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Accept',
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
                          //remove report only
                          // dbRef
                          //     .child('reportPost')
                          //     .child(reportDetail['reportID'].toString())
                          //     .remove()
                          //     .then((_) {
                          //   setState(() {
                          //     reportDetailsList.removeWhere((report) =>
                          //         report['reportID'] ==
                          //         reportDetail['reportID']);
                          //   });
                          // });
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                        label: const Text('Decline',
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
