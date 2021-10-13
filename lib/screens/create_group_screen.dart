import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/submit_button.dart';
import 'package:flutter_assignme/screens/components/icon_text_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/toast.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  late FToast fToast;

  Future createGroup() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (groupNameController.text.isEmpty) {
      fToast.showToast(
        child: toast('Group name is required.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    } else {
      DocumentReference groupDoc = await FirebaseFirestore.instance.collection('groups').add({
        'owners': user!.uid,
        'groupName': groupNameController.text,
        'members': FieldValue.arrayUnion([user.uid]),
      });
      FirebaseFirestore.instance.collection('groups').doc(groupDoc.id).update({
        'gid': groupDoc.id,
      });
      DocumentReference channelDoc = await FirebaseFirestore.instance.collection('channels').add({
        'gid': groupDoc.id,
        'groupName': groupNameController.text,
        'channelName': 'General',
      });
      FirebaseFirestore.instance.collection('channels').doc(channelDoc.id).update({
        'cid': channelDoc.id,
      }).then((value) => Navigator.pop(context));
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: Container(
        color: Colors.grey[900],
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[850],
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Your Group',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Text(
                          'Teachers are owners of class groups and students participate as members.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 30),
                      IconTextInput(
                        controller: groupNameController,
                        obscureText: false,
                        icon: 'group',
                        hint: 'Group name',
                        clear: true,
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                  SubmitButton(
                      title: 'Create Group',
                      onPressed: () async {
                        createGroup();
                      }),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
