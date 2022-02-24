import 'package:chat_app_firebase/Globals/global_vars.dart';
import 'package:chat_app_firebase/chat/chat_room.dart';
import 'package:chat_app_firebase/dummy/dummy_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userRef = FirebaseFirestore.instance.collection('user');
  CollectionReference ref = FirebaseFirestore.instance.collection("user");
  String nestedDocId;
  String chatUserName;
  String chatUserid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
              itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
              itemBuilder: (_, index) {
                if (snapshot.data.docs[index].get('user_id') ==
                    GlobalVars.loggedInUserId) {
                  GlobalVars.loggedUserName =
                      snapshot.data.docs[index].get('name').toString();
                } else {}
                return GestureDetector(
                  onTap: () {

                    // print("you wanna chat with ${snapshot.data.docs[index].get('name')} and his user id is ${snapshot.data.docs[index].get('user_id')}");
                    GlobalVars.chatUserName =
                        snapshot.data.docs[index].get('name').toString();
                    GlobalVars.chatUserId =
                        snapshot.data.docs[index].get('user_id').toString();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DummyChat()));
                  },
                  child: snapshot.data.docs[index].get('user_id') ==
                          GlobalVars.loggedInUserId
                      ? Container()
                      : Card(
                          child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            title: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data.docs[index].get('name'),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    snapshot.data.docs[index].get('email'),
                                  ),
                                ),
                                // Text(snapshot.data.docChanges[index].doc('title')),
                              ],
                            ),
                          ),
                        ),
                );
              },
            );
          }),
    );
  }

  Future updateUserId() async {
    print("trying to upade");
    userRef.doc(GlobalVars.loggedInUserId).update({
      "user_id": GlobalVars.loggedInUserId.toString(),
    });
  }
}
