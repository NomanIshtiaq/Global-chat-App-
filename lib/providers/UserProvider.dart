import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String username = "";
  String Email = "";
  String userid = "";

  var db = FirebaseFirestore.instance;

  var authuser = FirebaseAuth.instance.currentUser;

  void getUsrDetails() async {
    var authuser = FirebaseAuth.instance.currentUser;
    await db.collection("Users").doc(authuser!.uid).get().then((datasnapshot) {
      username = datasnapshot.data()?["name"] ?? "";
      Email = datasnapshot.data()?["Email"] ?? "";
      userid = datasnapshot.data()?["id"] ?? "";
    });
  }
}
