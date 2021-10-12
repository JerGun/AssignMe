import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future joinGroup(String docID, String groupID) async {
    FirebaseFirestore.instance.collection('invites').doc(docID).update({'status': true});
    FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'members': FieldValue.arrayUnion([widget.uid])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.625,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[850],
      child: Column(
        children: [
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[850],
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Notifications',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Notifications');
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => CreateMessageScreen()))
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: Behavior(),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('invites')
                    .where('invitee', isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (!snapshot.data!.docs[index].get('status'))
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.55,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      'INVITED YOU TO JOIN',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index].get('groupName'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        joinGroup(
                                          snapshot.data!.docs[index].id,
                                          snapshot.data!.docs[index].get('gid'),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 30),
                                          primary: Colors.green),
                                      child: Text(
                                        'Join',
                                      ),
                                    ),
                                    SizedBox(height: 2)
                                  ],
                                ),
                              ),
                            ],
                          );
                        if (index == 0)
                          return Center(
                            child: Container(
                              color: Colors.white,
                              child: Text('Notifications'),
                            ),
                          );
                        return SizedBox();
                      },
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
