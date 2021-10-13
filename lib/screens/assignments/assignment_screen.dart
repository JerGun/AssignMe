import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:flutter_assignme/screens/components/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({
    Key? key,
    required this.gid,
    required this.groupName,
    required this.cid,
    required this.channelName,
    required this.aid,
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
  final String aid;
  final String title;
  final String descriptions;
  final num points;
  final String dateDue;
  final String timeDue;

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final List files = [];
  final List url = [];
  late Future<String> urlDownload;
  late Size listviewSize;
  late FToast fToast;

  String? filePath;
  String fileName = '';
  File? file;

  Future getFileAndUpload() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePath = result.files.first.path;
        file = File(filePath!);
        fileName = '${DateTime.now().millisecondsSinceEpoch}_${result.files.first.name}';
      });
      Reference ref = FirebaseStorage.instance.ref('uploads/$fileName');
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        files.add({'fileName': fileName, 'url': urlDownload});
        url.add(urlDownload);
        print(url);
      });
    }
  }

  removeFile(String urlDownload) {
    url.removeWhere((element) => element == urlDownload);
    print(url);
  }

  Future openFile() async {
    if (filePath != null) {
      await OpenFile.open(filePath);
    }
  }

  Future newResponse() async {
    if (url.length == 0) {
      fToast.showToast(
        child: toast('Works are empty please attach file.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    } else {
      DocumentReference responseDoc = await FirebaseFirestore.instance.collection('responses').add({
        'aid': widget.aid,
        'assignee': user!.uid,
        'url': FieldValue.arrayUnion(url),
      });
      FirebaseFirestore.instance.collection('responses').doc(responseDoc.id).update({'rid': responseDoc.id}).then((value) => Navigator.pop(context));
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
            onPressed: () {
              newResponse();
            },
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
                  Container(
                    height: 55.0 * files.length,
                    child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[700],
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    openFile();
                                  },
                                  style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.insert_drive_file, color: Colors.white),
                                          SizedBox(width: 10),
                                          Text(
                                            '${files[index]['fileName']}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            removeFile(files[index]['url']);
                                            files.removeAt(index);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          );
                        }),
                  ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
