import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:globachat/providers/UserProvider.dart';

class Adduser extends StatefulWidget {
  const Adduser({super.key});

  @override
  State<Adduser> createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> userdata() async {
    String em = email.text.trim();

    if (em.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter email")));
      return;
    }

    var db = FirebaseFirestore.instance;

    try {
      var result = await db
          .collection("Users")
          .where("Email", isEqualTo: em)
          .get();

      if (result.docs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User not found")));
        return;
      }

      var otherUser = result.docs.first;
      String otherUserId = otherUser.id;
      String otherUsername = otherUser["name"] ?? "User";

      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      String currentUsername = Provider.of<UserProvider>(
        context,
        listen: false,
      ).username;

      if (currentUserId == otherUserId) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("You cannot add yourself")));
        return;
      }

      var existing = await db
          .collection("Chatrooms")
          .where("Users", arrayContains: currentUserId)
          .get();

      for (var doc in existing.docs) {
        List users = doc["Users"] ?? [];

        if (users.contains(otherUserId)) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Chat already exists")));
          return;
        }
      }

      await db.collection("Chatrooms").add({
        "Users": [currentUserId, otherUserId],
        "name": {currentUserId: currentUsername, otherUserId: otherUsername},
        "last_message": "",
        "last_time": FieldValue.serverTimestamp(),
        "desc": "New chat created",
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("User added successfully")));

      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New User')),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "The Email is required";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(label: Text("Email")),
              ),
              TextFormField(
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "The password is required";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(label: Text("Password")),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  userdata();
                },
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
