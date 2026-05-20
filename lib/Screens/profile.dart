import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globachat/Screens/editprofile.dart';
import 'package:globachat/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? data = {};

  @override
  Widget build(BuildContext context) {
    var UsersProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("")),

      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              child: Text(
                UsersProvider.username.isNotEmpty
                    ? UsersProvider.username[0]
                    : "?",
              ),
            ),
            Text(UsersProvider.username),
            Text(UsersProvider.Email),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Editprofile();
                    },
                  ),
                );
              },
              child: Text('Edit Pofile'),
            ),
          ],
        ),
      ),
    );
  }
}
