import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globachat/Screens/splashScreen.dart';

class Signupcontrollers {
  static Future<void> createaccount({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String country,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userid = FirebaseAuth.instance.currentUser!.uid;

      var db = FirebaseFirestore.instance;
      Map<String, dynamic> data = {
        "name": name,
        "Email": email,
        "Country": country,
        "id": userid,
      };
      try {
        await db.collection("Users").doc(userid.toString()).set(data);
      } catch (e) {
        print(e);
      }

      print('Login');

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
