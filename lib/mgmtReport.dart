import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class mgmtReport extends StatefulWidget {
  static String routeName = '/mgmtReport';
  const mgmtReport({super.key});

  @override
  State<mgmtReport> createState() => _mgmtReportState();
}

class _mgmtReportState extends State<mgmtReport> {
  late DatabaseReference dbRef;
  List<Map<String, dynamic>> reportDetailsList = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();

    _fetchdata();
  }

  void _fetchdata() {
    //reportDetailsList.clear();
    dbRef.child('reportPost').onValue.listen((DatabaseEvent? snapshot) {
      if (snapshot != null && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> reportData = snapshot.snapshot.value as Map;
        reportData.forEach((key, value) {
          Map<dynamic, dynamic> reportDetails = value as Map;

          bool isDuplicate =
              reportDetailsList.any((element) => element['reportID'] == key);

          if (!isDuplicate) {
            Map<String, dynamic> reportMap = {
              'reportID': key,
              'content': reportDetails['content'],
              'postID': reportDetails['pid'],
              'timestamp': reportDetails['timestamp'],
              'userID': reportDetails['uid'],
              'postData': reportDetails['postData'],
            };
            print(reportMap);
            setState(() {
              reportDetailsList.add(reportMap);
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
          child: Text('Manage Report'),
        ),
      ),
      body: ListView.builder(
          itemCount: reportDetailsList.length,
          itemBuilder: (context, index) {
            if (index < 0 || index >= reportDetailsList.length) {
              // Debugging: Print the problematic index
              print('Invalid index: $index');
              return Container();
            }

            Map<String, dynamic> reportDetail = reportDetailsList[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'reportID: ${reportDetail['reportID']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'post content: ${reportDetail['postData']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'detail: ${reportDetail['content']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Post ID: ${reportDetail['postID']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Time report: ${reportDetail['timestamp']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Report by: ${reportDetail['userID']}',
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
                          dbRef
                              .child('Post')
                              .child(reportDetail['postID'].toString())
                              .remove();
                          //delete report
                          dbRef
                              .child('reportPost')
                              .child(reportDetail['reportID'].toString())
                              .remove()
                              .then((_) {
                            setState(() {
                              reportDetailsList.removeWhere((report) =>
                                  report['reportID'] ==
                                  reportDetail['reportID']);
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Delete post',
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
                          dbRef
                              .child('reportPost')
                              .child(reportDetail['reportID'].toString())
                              .remove()
                              .then((_) {
                            setState(() {
                              reportDetailsList.removeWhere((report) =>
                                  report['reportID'] ==
                                  reportDetail['reportID']);
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                        label: const Text('Decline report',
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