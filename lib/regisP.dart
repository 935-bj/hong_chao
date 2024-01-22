import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class regisP extends StatefulWidget {
  static String routename = '/regisP';
  final FirebaseAuth auth;
  final User? user;

  const regisP({Key? key, required this.auth, required this.user})
      : super(key: key);

  @override
  State<regisP> createState() => _regisPState();
}

class _regisPState extends State<regisP> {
  late DatabaseReference dbRef;
  final _formKey = GlobalKey<FormState>();
  XFile? image;
  final ImagePicker picker = ImagePicker();
  //controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> sendForm(String uid, String name, int phone, int nid) async {
    await dbRef
        .child('plaintiff_form')
        .child(uid)
        .update({'name': name, 'phone': phone, 'nid': nid});
    print('finished update data ;');
  }

  Future getImg(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Register as Plaintiff'),
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'real name',
                        ),
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          hintText: 'phone number',
                        ),
                      ),
                      TextFormField(
                        controller: _nidController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'national ID',
                        ),
                      ),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'phone number',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Upload evidence'),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Note'),
                                      content: Text(
                                          'upload a picture of your national ID card or your pastport if you are foreigner '),
                                      actions: [
                                        //close the dialog box
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Icon(Icons.help_outline),
                          )
                        ],
                      ),
                      ElevatedButton(
                        //if user click this button, user can upload image from gallery
                        onPressed: () {
                          Navigator.pop(context);
                          getImg(ImageSource.gallery);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.image_rounded),
                            Text('Upload photo from Gallery'),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _nidController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('all filed need to be filled',
                              style: TextStyle(fontSize: 20)),
                          duration: Duration(seconds: 10),
                        ),
                      );
                    } else {
                      sendForm(
                          widget.user!.uid,
                          _nameController.text,
                          int.parse(_phoneController.text),
                          int.parse(_nidController.text));
                    }
                  },
                  child: const Text('submit')),
            )
          ]),
    );
  }
}
