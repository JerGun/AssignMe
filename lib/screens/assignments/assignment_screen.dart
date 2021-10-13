import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({
    Key? key,
    required this.gid,
    required this.groupName,
    required this.cid,
    required this.channelName,
    required this.title,
    required this.descriptions,
    required this.points,
    required this.dateDue,
    required this.timeDue,
  }) : super(key: key);

  final String gid;
  final String groupName;
  final String cid;
  final String channelName;
  final String title;
  final String descriptions;
  final num points;
  final String dateDue;
  final String timeDue;

  Future getFileAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
 
    );
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      // Upload file
      await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$groupName | $channelName',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[850],
        child: ScrollConfiguration(
          behavior: Behavior(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Due $dateDue $timeDue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Desctiptions',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$descriptions',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Points',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$points',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'My works',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      getFileAndUpload();
                    },
                    style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                    child: Container(
                      width: 100,
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.attach_file,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Attach',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
