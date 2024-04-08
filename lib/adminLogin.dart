import 'package:flutter/material.dart';
import 'package:hong_chao/adminHome.dart';
import 'package:hong_chao/login.dart';

class adminLogin extends StatefulWidget {
  static String routeName = '/adminLogin';
  const adminLogin({super.key});

  @override
  State<adminLogin> createState() => _adminLoginState();
}

class _adminLoginState extends State<adminLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  count++;
                  if (count > 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('please try again later'),
                        duration: Duration(seconds: 15),
                      ),
                    );
                    //Navigator.pushNamed(context, login.routeName);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        login.routeName, (Route<dynamic> route) => false);
                  } else {
                    if (usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      if (usernameController.text == 'admin') {
                        if (passwordController.text == '3.1415926535') {
                          //Navigator.pushNamed(context, adminHome.routeName);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              adminHome.routeName,
                              (Route<dynamic> route) => false);
                        } else {
                          //show snackbox: password invalid
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('password invalid'),
                              duration: Duration(seconds: 7),
                            ),
                          );
                        }
                      } else {
                        //show snackbox: username invalid
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('username invalid'),
                            duration: Duration(seconds: 7),
                          ),
                        );
                      }
                    } else {
                      //show snackbox say username or password can not leave blank
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('username or password can not leave blank'),
                          duration: Duration(seconds: 7),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
