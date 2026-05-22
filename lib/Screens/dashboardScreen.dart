import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globachat/Screens/LoginScreen1.dart';
import 'package:globachat/Screens/adduser.dart';
import 'package:globachat/Screens/chatroomscreen.dart';
import 'package:globachat/Screens/profile.dart';
import 'package:globachat/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var db = FirebaseFirestore.instance;

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> getchatroomsStream() {
    return db
        .collection("Chatrooms")
        .where("Users", arrayContains: currentUserId)
        .snapshots();
  }

  void openAddUser() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => Adduser()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Global Chat"),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: openAddUser)],
        leading: InkWell(
          onTap: () => scaffoldkey.currentState!.openDrawer(),
          child: CircleAvatar(
            child: Text(
              userProvider.username.isNotEmpty
                  ? userProvider.username[0].toUpperCase()
                  : "?",
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userProvider.username),
              accountEmail: Text(userProvider.Email),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  userProvider.username.isNotEmpty
                      ? userProvider.username[0].toUpperCase()
                      : "?",
                ),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.people),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Profile()),
                );
              },
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Loginscreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getchatroomsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var chatrooms = snapshot.data!.docs;

          if (chatrooms.isEmpty) {
            return Center(child: Text("No Chats Yet"));
          }

          return ListView.builder(
            itemCount: chatrooms.length,
            itemBuilder: (context, index) {
              var chatroom = chatrooms[index].data() as Map<String, dynamic>;

              Map usernames = chatroom["name"] ?? {};

              String otherUsername = "User";

              usernames.forEach((key, value) {
                if (key != currentUserId) {
                  otherUsername = value;
                }
              });

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Chatroomscreen(
                        chatroomName: otherUsername,
                        chatroomid: chatrooms[index].id,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey[900],
                  child: Text(
                    otherUsername.isNotEmpty
                        ? otherUsername[0].toUpperCase()
                        : "?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(otherUsername),
                subtitle: Text(chatroom["last_message"] ?? ""),
              );
            },
          );
        },
      ),
    );
  }
}
