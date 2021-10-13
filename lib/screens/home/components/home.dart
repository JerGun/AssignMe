import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/assignments/assignment_screen.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScrollConfiguration(
      behavior: Behavior(),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('assignments').where('assigner', isEqualTo: user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AssignmentScreen(
                                            gid: snapshot.data!.docs[index].get('gid'),
                                            groupName: snapshot.data!.docs[index].get('groupName'),
                                            cid: snapshot.data!.docs[index].get('cid'),
                                            channelName: snapshot.data!.docs[index].get('channelName'),
                                            aid: snapshot.data!.docs[index].get('aid'),
                                            title: snapshot.data!.docs[index].get('title'),
                                            descriptions: snapshot.data!.docs[index].get('descriptions'),
                                            points: snapshot.data!.docs[index].get('points'),
                                            dateDue: snapshot.data!.docs[index].get('dateDue'),
                                            timeDue: snapshot.data!.docs[index].get('timeDue'),
                                          )));
                            },
                            style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: Expanded(
                                      child: Text(
                                        '${snapshot.data!.docs[index].get('groupName')} | ${snapshot.data!.docs[index].get('channelName')}',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    snapshot.data!.docs[index].get('title'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Due ${snapshot.data!.docs[index].get('dateDue')} ${snapshot.data!.docs[index].get('timeDue')}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
      ),
    ));
  }
}
