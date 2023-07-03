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
  final TextEditingController _roomfee = TextEditingController();
  final TextEditingController _otherfee = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> setRate(num wrate, num erate, num roomFee, num otherFee) async {
    await dbRef.update({
      'wrate': wrate,
      'erate': erate,
      'roomFee': roomFee,
      'otherFee': otherFee
    });
    print('finished update rate data ;');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า'),
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
                fontSize: 20),
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
                            hintStyle: TextStyle(fontSize: 18))),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _etextEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 225, 207, 243),
                            filled: true,
                            hintText: 'ใส่ค่าไฟต่อหน่วย',
                            hintStyle: TextStyle(fontSize: 18))),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _roomfee,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 225, 207, 243),
                            filled: true,
                            hintText: 'ใส่ค่าห้อง',
                            hintStyle: TextStyle(fontSize: 18))),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _otherfee,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 225, 207, 243),
                            filled: true,
                            hintText: 'ใส่ค่าอื่นๆ',
                            hintStyle: TextStyle(fontSize: 18))),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_etextEditingController.text.isEmpty ||
                            _wtextEditingController.text.isEmpty ||
                            _otherfee.text.isEmpty ||
                            _roomfee.text.isEmpty) {
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
                          num? roomFee = num.tryParse(_roomfee.text);
                          num? otherFee = num.tryParse(_otherfee.text);

                          if (wrate != null &&
                              erate != null &&
                              roomFee != null &&
                              otherFee != null) {
                            setRate(wrate, erate, roomFee, otherFee);
                            _etextEditingController.clear();
                            _wtextEditingController.clear();
                            _roomfee.clear();
                            _otherfee.clear();
                          }
                        }
                      },
                      child:
                          const Text('เสร็จ', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
