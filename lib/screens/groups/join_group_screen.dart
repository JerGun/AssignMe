import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({Key? key}) : super(key: key);

  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final TextEditingController searchController = TextEditingController();

  final TextEditingController groupNameController = TextEditingController();
  late FToast fToast;

  User? user = FirebaseAuth.instance.currentUser;

  Future requestJoin(String requesteeID) async {
    // if (inviteeID != user!.uid) {
    //   FirebaseFirestore.instance.collection('invites').add({
    //     'gid': widget.gid,
    //     'groupName': widget.groupName,
    //     'invitee': inviteeID,
    //     'inviter': user!.uid,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //     'status': false,
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> streamAll = FirebaseFirestore.instance.collection('groups').snapshots();

    Stream<QuerySnapshot> streamTag =
        FirebaseFirestore.instance.collection('groups').where('tag', isEqualTo: searchController.text.length > 1 ? searchController.text.substring(1) : searchController.text).snapshots();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Join Group',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
                  margin: EdgeInsets.only(top: 10),
                  child: ScrollConfiguration(
                    behavior: Behavior(),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: searchController.text.isEmpty ? streamAll : streamTag,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow)),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (!snapshot.data!.docs[index].get('members').contains(user!.uid))
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: snapshot.data!.docs[index].get('img') != '' ? Colors.transparent : Colors.grey,
                                          backgroundImage: NetworkImage('${snapshot.data!.docs[index].get('img')}'),
                                          child: snapshot.data!.docs[index].get('img') != ''
                                              ? Container()
                                              : Text(
                                                  snapshot.data!.docs[index].get('groupName').substring(0, 2).toUpperCase(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          snapshot.data!.docs[index].get('groupName'),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // if (user!.uid != snapshot.data!.docs[index].get('uid')) inviteMember(snapshot.data!.docs[index].get('uid'));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          fixedSize: Size(MediaQuery.of(context).size.width * 0.25, 30),
                                          primary: Colors.green),
                                      child: Text(
                                        'Request',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            return SizedBox();
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
      ),
    );
  }
}
