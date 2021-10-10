import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/submit_button.dart';
import 'package:flutter_assignme/screens/components/text_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();

  Future createGroup() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (groupNameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Group name is required.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      DocumentReference groupDoc = await FirebaseFirestore.instance.collection('groups').add({
        'owners': user!.uid,
        'name': groupNameController.text,
      });
      FirebaseFirestore.instance.collection('groups').doc(groupDoc.id).update({'gid': groupDoc.id});
      FirebaseFirestore.instance.collection('channels').add({
        'group': groupDoc.id,
        'name': 'General',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    margin: EdgeInsets.only(top: 40, left: 20),
                    child: TextButton(
                      onPressed: () {
                        Fluttertoast.cancel();
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
                    TextInput(
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
                      createGroup().then((value) => {
                            Fluttertoast.cancel(),
                            Navigator.pop(context),
                          });
                    }),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
