import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/icon_text_input.dart';
import 'components/toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
    required this.img,
  }) : super(key: key);

  final String img;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController channelNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  late String urlDownload = '';
  late FToast fToast;

  String? filePath;
  String fileName = '';
  File? file;

  User? user = FirebaseAuth.instance.currentUser;

  Future editProfile() async {
    firstNameController.text.isEmpty
        ? fToast.showToast(
            child: toast('First name is required.'),
            gravity: ToastGravity.BOTTOM,
            toastDuration: Duration(seconds: 2),
          )
        : lastNameController.text.isEmpty
            ? fToast.showToast(
                child: toast('Last name is required.'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 2),
              )
            : await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'img': urlDownload,
              }).then((value) => Navigator.pop(context));
  }

  Future getFileAndUpload() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
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
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    urlDownload = widget.img;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.grey[900],
          actions: [
            IconButton(
                onPressed: () {
                  editProfile();
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
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: InkWell(
                        onTap: () {
                          getFileAndUpload();
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(urlDownload),
                          child: urlDownload != ''
                              ? Container()
                              : Text(
                                  firstNameController.text.isEmpty || lastNameController.text.isEmpty ? '' : '${firstNameController.text[0].toUpperCase()}${lastNameController.text[0].toUpperCase()}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    IconTextInput(controller: firstNameController, hint: 'First Name', icon: 'person', obscureText: false),
                    SizedBox(height: 10),
                    IconTextInput(controller: lastNameController, hint: 'Last Name', icon: 'person', obscureText: false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
