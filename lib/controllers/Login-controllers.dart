import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globachat/Screens/splashScreen.dart';

class Logincontrollers {
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Created');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign-up'),
            content: Text('The account is created succesfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Splashscreen();
          },
        ),
        (route) {
          return false;
        },
      );
    } catch (e) {
      SnackBar messagesnack = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(messagesnack);
      print(e);
    }
  }
}
