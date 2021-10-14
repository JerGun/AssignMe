import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:flutter_assignme/screens/components/settings_option.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({
    Key? key,
    required this.gid,
    required this.groupName,
  }) : super(key: key);

  final String gid;
  final String groupName;

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  double? topPadding;

  Future kickMember(String docID, String uid) async {
    FirebaseFirestore.instance.collection('groups').doc(docID).update({
      'members': FieldValue.arrayRemove([uid])
    }).then((value) => {Navigator.pop(context), Navigator.pop(context)});
  }

  List members = [];

  @override
  Widget build(BuildContext context) {
    topPadding = MediaQuery.of(context).padding.top;

    if (widget.groupName != 'Notification')
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('groups').where('gid', isEqualTo: widget.gid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data!.docs.length != 0) members = snapshot.data!.docs[0].get('members');
                  return Padding(
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
                              members.length.toString(),
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
                              child: ListView.builder(
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
                                                        width: MediaQuery.of(context).size.width,
                                                        color: Colors.grey[850],
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(top: 40, left: 20, right: 20),
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
                                                                    data['role'] == 'teacher' ? 'T${data['role'].toString().substring(1)}' : 'S${data['role'].toString().substring(1)}',
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
                                                                    snapshot.data!.docs[0].get('groupName'),
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
                                                                        SettingsOption(
                                                                          title: 'Manage User',
                                                                          icon: Icons.settings,
                                                                          onPressed: () {},
                                                                        ),
                                                                        SettingsOption(
                                                                          title: 'Kick',
                                                                          icon: Icons.close,
                                                                          color: Colors.red,
                                                                          onPressed: () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  title: Text(
                                                                                    "Kick '${data['firstName']} ${data['lastName']}'",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  content: Text(
                                                                                    'Are you sure you want to kick ${data['firstName']} ${data['lastName']}? They will able to rejoin with a new invite',
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 14,
                                                                                    ),
                                                                                  ),
                                                                                  backgroundColor: Colors.grey[800],
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        'Cancle',
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      width: 100,
                                                                                      height: 40,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.red,
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: TextButton(
                                                                                        onPressed: () {
                                                                                          kickMember(snapshot.data!.docs[0].id, data['uid']);
                                                                                        },
                                                                                        child: Text(
                                                                                          'Confirm',
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                              },
                                              style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage('${data['img']}'),
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );

    return Container();
  }
}
