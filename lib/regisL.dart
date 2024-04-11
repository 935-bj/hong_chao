import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hong_chao/authService.dart';
import 'package:hong_chao/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class regisL extends StatefulWidget {
  static String routeName = '/regisL';
  const regisL({super.key});

  @override
  State<regisL> createState() => _regisLState();
}

class _regisLState extends State<regisL> {
  late DatabaseReference dbRef;
  final _formKey = GlobalKey<FormState>();
  String nidUrl = '';
  String lidUrl = '';
  //controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _lidController = TextEditingController();

  //auth -
  FirebaseAuth auth = AuthService.authInstance;
  User? user = AuthService.currentUser;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
  }

  Future<void> sendForm(String uid, String name, int phone, int nid, int lid,
      String nidUrl, String lidUrl) async {
    await dbRef.child('lawyer_form').child(uid).update({
      'name': name,
      'phone': phone,
      'nid': nid,
      'lid': lid,
      'nidUrl': nidUrl,
      'lidUrl': lidUrl,
    });
    print('finished update data ;');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Register as Lawyer'),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text('Name Lastname'),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'real name',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Phone number'),
                      const SizedBox(
                        height: 5,
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Attorney-at-law License Number'),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _lidController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'put license number with out slash',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('National ID'),
                      const SizedBox(
                        height: 5,
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text('Upload evidence'),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Note'),
                                      content: const Text(
                                          'upload a picture of your national ID card and Attorney-at-law License '),
                                      actions: [
                                        //close the dialog box
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(Icons.help_outline),
                          )
                        ],
                      ),
                      //ID card
                      ElevatedButton(
                        //if user click this button, user can upload image from gallery
                        onPressed: () async {
                          //get the img from gallery
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          print('The path is: ${file?.path}');
                          if (file == null) print('file null');

                          //get ref to storage
                          Reference root = FirebaseStorage.instance.ref();
                          Reference Dir = root.child('nid_card');
                          Reference uploadTo = Dir.child('${user?.uid}.jpg');

                          //upload
                          try {
                            await uploadTo.putFile(File(file!.path));
                            nidUrl = await uploadTo.getDownloadURL();
                            print(nidUrl);
                          } catch (error) {}
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.image_rounded),
                            Text('Upload a picture of National ID card'),
                          ],
                        ),
                      ),
                      //Attorney-at-law License
                      ElevatedButton(
                        onPressed: () async {
                          //get the img from gallery
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          print('The path is: ${file?.path}');
                          if (file == null) print('file null');

                          //get ref to storage
                          Reference root = FirebaseStorage.instance.ref();
                          Reference Dir = root.child('lid_card');
                          Reference uploadTo = Dir.child('${user?.uid}.jpg');

                          //upload
                          try {
                            await uploadTo.putFile(File(file!.path));
                            lidUrl = await uploadTo.getDownloadURL();
                            print(nidUrl);
                          } catch (error) {}
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.image_rounded),
                            Text('Upload a picture of Attorney-at-law License'),
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
                        _nidController.text.isEmpty ||
                        _lidController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('all filed need to be filled',
                              style: TextStyle(fontSize: 20)),
                          duration: Duration(seconds: 10),
                        ),
                      );
                    }
                    if (nidUrl.isEmpty || lidUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'you must upload the evidences before submit the form',
                              style: TextStyle(fontSize: 20)),
                          duration: Duration(seconds: 10),
                        ),
                      );
                    } else {
                      sendForm(
                        '${user?.uid}',
                        _nameController.text,
                        int.parse(_phoneController.text),
                        int.parse(_nidController.text),
                        int.parse(_lidController.text),
                        nidUrl,
                        lidUrl,
                      );
                      _nameController.clear();
                      _lidController.clear();
                      _nidController.clear();
                      _phoneController.clear();
                      nidUrl = '';
                      lidUrl = '';
                    }
                    //Navigator.pushNamed(context, home.routeName);
                    Navigator.pop(context);
                  },
                  child: const Text('submit')),
            )
          ])),
    );
  }
}
