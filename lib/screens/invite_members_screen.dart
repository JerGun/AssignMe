import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/behavior.dart';

class InviteMemberScreen extends StatefulWidget {
  const InviteMemberScreen({Key? key, required this.groupID}) : super(key: key);

  final String groupID;

  @override
  _InviteMemberScreenState createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  final TextEditingController searchController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  Future inviteMember(String inviteeID) async {
    if (inviteeID == user!.uid) {
      FirebaseFirestore.instance.collection('invites').add({
        'group': widget.groupID,
        'invitee': inviteeID,
        'inviter': user!.uid,
        'status': false,
      });
    } else {
      Fluttertoast.showToast(
        msg: "Can't invite yourself",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invite Members',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[850],
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[800],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Search with tag (example: ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '#5134',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        ')',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ScrollConfiguration(
                  behavior: Behavior(),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('tag',
                            isEqualTo: searchController.text.length > 1
                                ? searchController.text.substring(1)
                                : searchController.text)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      snapshot.data!.docs[index].get('firstName'),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    inviteMember(snapshot.data!.docs[index].get('uid'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      fixedSize: Size(MediaQuery.of(context).size.width * 0.2, 30),
                                      primary: Colors.yellow),
                                  child: Text(
                                    'Invite',
                                    style: TextStyle(color: Colors.grey[850]),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
