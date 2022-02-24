import 'package:chat_app_firebase/Globals/global_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  void initState() {
    // TODO: implement initState

    createChatRoom();//]]]]]]]]]]]]]]]]]]]]]]] call this fun at send msg function
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(GlobalVars.chatUserName ?? " "),
        ),
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Lets chat with'),
              Text(GlobalVars.chatUserName ?? "",style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
              ),)
            ],
          ),
        ),
      ),
    );
  }

  Future createChatRoom() async {
    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(GlobalVars.loggedInUserId+GlobalVars.chatUserId)
        .collection("messages")
        .add({
      'sender_id': GlobalVars.loggedInUserId,
      'msg': 'hello ',
      'time': 'today',
      'room_id': GlobalVars.loggedInUserId+GlobalVars.chatUserId,
      'base_string': '',
      'sender_name': GlobalVars.loggedUserName,
    });
  }
}
