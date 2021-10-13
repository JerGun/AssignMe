import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:open_file/open_file.dart';

class AssignmentScreen extends StatefulWidget {
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

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  String? filePath;
  String fileName = '';
  File? file;
  late Future<String> urlDownload;

  Future getFileAndUpload() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Uint8List? fileBytes = result.files.first.bytes;
      setState(() {
        filePath = result.files.first.path;
        file = File(filePath!);
        fileName = result.files.first.name;
      });

      Reference ref = FirebaseStorage.instance.ref('uploads/$fileName');

      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download-Link: $urlDownload');
    }
  }

  Future openFile() async {
    if (filePath != null) {
      print(filePath);
      await OpenFile.open(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.groupName} | ${widget.channelName}',
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
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Due ${widget.dateDue} ${widget.timeDue}',
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
                    '${widget.descriptions}',
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
                    '${widget.points}',
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
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            openFile();
                          },
                          child: Text('File Name: $fileName')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
