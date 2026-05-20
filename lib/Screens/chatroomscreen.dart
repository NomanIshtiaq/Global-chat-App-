import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globachat/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class Chatroomscreen extends StatefulWidget {
  String chatroomName;
  String chatroomid;
  Chatroomscreen({
    super.key,
    required this.chatroomName,
    required this.chatroomid,
  });

  @override
  State<Chatroomscreen> createState() => _ChatroomscreenState();
}

class _ChatroomscreenState extends State<Chatroomscreen> {
  var db = FirebaseFirestore.instance;

  TextEditingController messageText = TextEditingController();
  Future<void> sendmessage() async {
    if (messageText.text.isEmpty) {
      return;
    }
    Map<String, dynamic> messagetosend = {
      "text": messageText.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).username,
      "timestamp": FieldValue.serverTimestamp(),
    };
    try {
      await db.collection("message").add(messagetosend);
    } catch (e) {}
    messageText.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatroomName)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db
                  .collection("message")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                var allmessages = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: allmessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var messages = allmessages[index];
                    var currentuser = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).username;

                    bool isme = messages["sender_name"] == currentuser;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: isme
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages["sender_name"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Align(
                              alignment: isme
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                                decoration: BoxDecoration(
                                  color: isme ? Colors.green : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(allmessages[index]["text"]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageText,
                      decoration: InputDecoration(
                        hintText: 'Write the message here.......',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      sendmessage();
                    },
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
