import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:flutter_assignme/screens/members/components/manage_member_option.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key, required this.groupID, required this.numberMembers}) : super(key: key);

  final String groupID;
  final int numberMembers;

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  double? topPadding;

  @override
  Widget build(BuildContext context) {
    topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[900],
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.825,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[850],
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'MEMBERS — ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.numberMembers.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: ScrollConfiguration(
                      behavior: Behavior(),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('groups')
                            .where('gid', isEqualTo: widget.groupID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            var members = snapshot.data!.docs[0].get('members');
                            return ListView.builder(
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance.collection('users').doc(members[index]).get(),
                                  builder: (context, userSnapshot) {
                                    if (!userSnapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      Map<String, dynamic> data = userSnapshot.data!.data() as Map<String, dynamic>;
                                      return Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              if (data['uid'] != user!.uid)
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                      child: Center(
                                                          child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width,
                                                              color: Colors.grey[850],
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin:
                                                                        EdgeInsets.only(top: 40, left: 20, right: 20),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          width: 80,
                                                                          height: 80,
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.circular(100),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 20),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              '${data['firstName']} ${data['lastName']}',
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 10),
                                                                            Text(
                                                                              '#${data['tag']}',
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        Text(
                                                                          data['role'] == 'teacher'
                                                                              ? 'T${data['role'].toString().substring(1)}'
                                                                              : 'S${data['role'].toString().substring(1)}',
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.all(20),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          snapshot.data!.docs[0].get('name'),
                                                                          style: TextStyle(
                                                                            color: Colors.grey,
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width,
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.grey[800],
                                                                            borderRadius: BorderRadius.circular(10),
                                                                          ),
                                                                          child: Column(
                                                                            children: [
                                                                              ManageMembersOption(
                                                                                title: 'Manage User',
                                                                                icon: Icons.settings,
                                                                                onPressed: () {},
                                                                              ),
                                                                              ManageMembersOption(
                                                                                title: 'Kick',
                                                                                icon: Icons.close,
                                                                                color: Colors.red,
                                                                                onPressed: () {},
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    );
                                                  },
                                                );
                                            },
                                            style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(50), color: Colors.grey),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  '${data['firstName']} ${data['lastName']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
