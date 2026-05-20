import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globachat/Screens/LoginScreen1.dart';
import 'package:globachat/Screens/chatroomscreen.dart';
import 'package:globachat/Screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globachat/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  List<Map<String, dynamic>> chatroomslist = [];

  List<String> chatroomids = [];

  var scaffoldkey = GlobalKey<ScaffoldState>();

  var db = FirebaseFirestore.instance;
  var authuser = FirebaseAuth.instance.currentUser;
  void getchatrooms() {
    db.collection("Chatrooms").get().then((dataSnapshot) {
      for (var singlechatroom in dataSnapshot.docs) {
        chatroomslist.add(singlechatroom.data());
        chatroomids.add(singlechatroom.id.toString());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getchatrooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var UsersProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('Global Chat '),
        leading: InkWell(
          splashColor: Colors.blueGrey[900],

          onTap: () {
            scaffoldkey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
              child: Text(
                UsersProvider.username.isNotEmpty
                    ? UsersProvider.username[0].toUpperCase()
                    : "?",
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(UsersProvider.username),
              accountEmail: Text(UsersProvider.Email),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  UsersProvider.username.isNotEmpty
                      ? UsersProvider.username[0].toUpperCase()
                      : "?",
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Profile();
                    },
                  ),
                );
              },
              leading: Icon(Icons.people),
              title: Text("Profile"),
            ),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Loginscreen();
                    },
                  ),
                );
              },
              leading: Icon(Icons.logout),
              title: Text("logout"),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: chatroomslist.length,
        itemBuilder: (BuildContext context, int index) {
          String chatroomlist = chatroomslist[index]["chatroom_name"] ?? " ";
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Chatroomscreen(
                      chatroomName: chatroomlist,
                      chatroomid: chatroomids[index],
                    );
                  },
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[900],
              child: Text(
                chatroomlist[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(chatroomlist),
            subtitle: Text(chatroomslist[index]['desc']),
          );
        },
      ),
    );
  }
}
