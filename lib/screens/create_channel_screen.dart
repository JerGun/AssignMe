import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/text_input.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  final String groupID;

  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final TextEditingController channelNameController = TextEditingController();

  Future createChannel() async {
    channelNameController.text.isEmpty
        ? Fluttertoast.showToast(
            msg: "Channel name is required.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          )
        : FirebaseFirestore.instance.collection('channels').add({
            'group': widget.groupID,
            'name': channelNameController.text,
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Channel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
              onPressed: () {
                createChannel().then((value) => {
                      Fluttertoast.cancel(),
                      Navigator.pop(context),
                    });
              },
              icon: Icon(Icons.check)),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[850],
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  TextInput(
                    controller: channelNameController,
                    obscureText: false,
                    icon: 'channel',
                    hint: 'Channel name',
                    clear: true,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
