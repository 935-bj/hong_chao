import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class seting extends StatefulWidget {
  static String routeName = '/seting';
  const seting({super.key});

  @override
  State<seting> createState() => _setingState();
}

class _setingState extends State<seting> {
  final TextEditingController _etextEditingController = TextEditingController();
  final TextEditingController _wtextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> setRate(num wrate, num erate) async {
    await dbRef.set({'wrate': wrate, 'erate': erate});
    print('finished update rate data ;');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HongChao'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'SET UP YOUR HONG-CHAO',
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: _wtextEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 225, 207, 243),
                          filled: true,
                          hintText: 'ใส่ค่าน้ำต่อหน่วย',
                        )),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _etextEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 225, 207, 243),
                          filled: true,
                          hintText: 'ใส่ค่าไฟต่อหน่วย',
                        )),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_etextEditingController.text.isEmpty ||
                            _wtextEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('กรุณาใส่ข้อมูลให้ครบทุกช่อง'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        } else {
                          num? wrate =
                              num.tryParse(_wtextEditingController.text);
                          num? erate =
                              num.tryParse(_etextEditingController.text);
                          if (wrate != null && erate != null) {
                            setRate(wrate, erate);
                            _etextEditingController.clear();
                            _wtextEditingController.clear();
                          }
                        }
                      },
                      child: const Text('เสร็จ'),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
