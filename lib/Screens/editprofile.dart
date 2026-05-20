import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globachat/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _ProfileState();
}

class _ProfileState extends State<Editprofile> {
  TextEditingController editName = TextEditingController();
  Map<String, dynamic>? data = {};
  var db = FirebaseFirestore.instance;
  void updatename() {
    Map<String, dynamic> datatoupdate = {"name": editName.text};

    db
        .collection("Users")
        .doc(Provider.of<UserProvider>(context, listen: false).userid)
        .update(datatoupdate);

    Provider.of<UserProvider>(context, listen: false).getUsrDetails();
  }

  @override
  void initState() {
    editName.text = Provider.of<UserProvider>(context, listen: false).username;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Editprofile"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.blueGrey,
              onTap: () {
                updatename();
                Navigator.pop(context);
              },
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: editName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Field Should not be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(label: Text('Edit Name ')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
