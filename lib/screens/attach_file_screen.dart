import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AttachFileScreen extends StatefulWidget {
  const AttachFileScreen({
    Key? key,
    required this.gid,
    required this.userRole,
  }) : super(key: key);

  final String gid;
  final String userRole;

  @override
  _AttachFileScreenState createState() => _AttachFileScreenState();
}

class _AttachFileScreenState extends State<AttachFileScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  late String urlDownload = '';

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
      urlDownload = await snapshot.ref.getDownloadURL();

      final kb = result.files.first.size / 1024;
      final mb = kb / 1024;
      final fileSize = (mb >= 1) ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
      DocumentReference fileDoc = await FirebaseFirestore.instance.collection('files').add({
        'adder': user!.uid,
        'fileName': fileName,
        'fileSize': fileSize,
        'gid': widget.gid,
      });
      FirebaseFirestore.instance.collection('files').doc(fileDoc.id).update({
        'fid': fileDoc.id,
      });
    }
  }

  Future deleteFile(String fid) async {
    FirebaseFirestore.instance.collection('files').doc(fid).delete().then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Files',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.grey[900],
          actions: [
            widget.userRole == 'teacher'
                ? IconButton(
                    onPressed: () {
                      getFileAndUpload();
                    },
                    icon: Icon(Icons.add))
                : SizedBox(),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[850],
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('files').where('gid', isEqualTo: widget.gid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow)),
                  );
                else if (snapshot.data!.docs.isEmpty)
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: Text(
                      'There is no file in this group.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[700],
                          ),
                          child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.insert_drive_file, color: Colors.white),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.65,
                                          child: Text(
                                            '${snapshot.data!.docs[index].get('fileName')}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data!.docs[index].get('fileSize')}',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Delete file '${snapshot.data!.docs[index].get('fileName')}'",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete file ${snapshot.data!.docs[index].get('fileName')}?',
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
                                                  onPressed: () async {
                                                    deleteFile(snapshot.data!.docs[index].get('fid'));
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
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
