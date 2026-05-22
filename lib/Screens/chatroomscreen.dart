import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
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
    if (messageText.text.isEmpty) return;

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    String username = Provider.of<UserProvider>(
      context,
      listen: false,
    ).username;

    // 📦 message object
    Map<String, dynamic> messagetosend = {
      "text": messageText.text,
      "sender_name": username,
      "sender_id": currentUserId, // ✅ important for identity
      "timestamp": FieldValue.serverTimestamp(),
      "chatroom_id": widget.chatroomid,
    };

    try {
      // ✅ add message
      await db.collection("message").add(messagetosend);

      // ⭐ ALSO UPDATE CHATROOM (THIS IS WHATSAPP LOGIC)
      await db.collection("Chatrooms").doc(widget.chatroomid).update({
        "last_message": messageText.text, // last message shown in dashboard
        "last_time": FieldValue.serverTimestamp(), // for sorting later
      });
    } catch (e) {
      print(e);
    }

    messageText.text = ""; // clear input
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatroomName)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // this is the stream builder used to rendered the message in realtime
            child: StreamBuilder(
              //stream is the  main part which have the stream data
              stream: db
                  .collection("message")
                  .where("chatroom_id", isEqualTo: widget.chatroomid)
                  //orderby is used to order the messages according to the time they sended
                  .orderBy(
                    "timestamp",
                    descending: false,
                  ) //snapshot has the data
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text("Some Error hass occured"));
                }
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
                                  maxWidth: //mediaquery is used to tell the how big the screen then we are a
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
