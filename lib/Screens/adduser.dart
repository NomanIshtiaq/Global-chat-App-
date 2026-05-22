import 'package:flutter/material.dart';

// ✅ ADD THESE IMPORTS (required for Firebase + Provider)
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
  // 🎯 Controllers for input fields
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // 🔥 MAIN FUNCTION (UPDATED)
  Future<void> userdata() async {
    String em = email.text.trim(); // get email input

    // ❌ stop if empty
    if (em.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter email")));
      return;
    }

    var db = FirebaseFirestore.instance;

    try {
      // 🔍 STEP 1: CHECK USER EXISTS IN FIRESTORE
      var result = await db
          .collection("Users") // ⚠️ must exist in your DB
          .where("Email", isEqualTo: em)
          .get();

      // ❌ if no user found
      if (result.docs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User not found")));
        return;
      }

      // ✅ GET OTHER USER DATA
      var otherUser = result.docs.first;
      String otherUserId = otherUser.id; // their UID
      String otherUsername = otherUser["name"] ?? "User";

      // ✅ CURRENT USER DATA
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      String currentUsername = Provider.of<UserProvider>(
        context,
        listen: false,
      ).username;

      // 🚫 prevent adding yourself
      if (currentUserId == otherUserId) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("You cannot add yourself")));
        return;
      }

      // 🔍 STEP 2: CHECK IF CHATROOM ALREADY EXISTS
      var existing = await db
          .collection("Chatrooms")
          .where("Users", arrayContains: currentUserId)
          .get();

      for (var doc in existing.docs) {
        List users = doc["Users"] ?? [];

        if (users.contains(otherUserId)) {
          // ❌ chat already exists
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Chat already exists")));
          return;
        }
      }

      // ✅ STEP 3: CREATE NEW CHATROOM
      await db.collection("Chatrooms").add({
        "Users": [currentUserId, otherUserId], // ⭐ both users
        // ⭐ store names for UI display
        "name": {currentUserId: currentUsername, otherUserId: otherUsername},

        "last_message": "", // initially empty
        "last_time": FieldValue.serverTimestamp(),

        "desc": "New chat created", // your original field
      });

      // ✅ SUCCESS MESSAGE
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("User added successfully")));

      Navigator.pop(context); // go back to dashboard
    } catch (e) {
      // ❌ ERROR HANDLING
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
              // 📧 EMAIL FIELD
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

              // 🔒 PASSWORD FIELD (not used here, but kept as you had it)
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

              // ➕ ADD BUTTON
              ElevatedButton(
                onPressed: () {
                  userdata(); // ✅ CALL UPDATED FUNCTION
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
