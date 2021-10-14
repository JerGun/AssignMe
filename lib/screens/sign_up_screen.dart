import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/submit_button.dart';
import 'package:flutter_assignme/screens/components/icon_text_input.dart';
import 'package:flutter_assignme/screens/home/home_screen.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'components/toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  late String urlDownload = '';
  late FToast fToast;

  String role = 'teacher';
  String? filePath;
  String fileName = '';
  File? file;

  User? user = FirebaseAuth.instance.currentUser;

  Future signUp() async {
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
                'role': role,
                'tag': Random().nextInt(9999).toString(),
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'img': urlDownload,
              }).then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                ));
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[850],
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 40, left: 20),
                            child: TextButton(
                              onPressed: () {
                                context.read<AuthenticationService>().signOutWithGoogle();
                              },
                              style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                              ),
                              child: Icon(
                                Icons.keyboard_backspace,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create Account',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'PLease fill the input blow here.',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 30),
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
                                            firstNameController.text.isEmpty || lastNameController.text.isEmpty
                                                ? ''
                                                : '${firstNameController.text[0].toUpperCase()}${lastNameController.text[0].toUpperCase()}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: role == 'teacher' ? Colors.yellow : Colors.grey[800]),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          role = 'teacher';
                                        });
                                      },
                                      child: Text(
                                        'Teacher',
                                        style: TextStyle(color: role == 'teacher' ? Colors.black : Colors.grey),
                                      ),
                                      style: ButtonStyle(
                                        splashFactory: NoSplash.splashFactory,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: role == 'student' ? Colors.yellow : Colors.grey[800]),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          role = 'student';
                                        });
                                      },
                                      child: Text(
                                        'Student',
                                        style: TextStyle(color: role == 'student' ? Colors.black : Colors.grey),
                                      ),
                                      style: ButtonStyle(
                                        splashFactory: NoSplash.splashFactory,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              IconTextInput(controller: firstNameController, hint: 'First Name', icon: 'person', obscureText: false),
                              SizedBox(height: 10),
                              IconTextInput(controller: lastNameController, hint: 'Last Name', icon: 'person', obscureText: false),
                              // TextInput(
                              //     controller: emailController,
                              //     hint: 'Email',
                              //     icon: 'email',
                              //     obscureText: false),
                              // SizedBox(height: 10),
                              // TextInput(
                              //     controller: passwordController,
                              //     hint: 'Password',
                              //     icon: 'password',
                              //     obscureText: true),
                              // SizedBox(height: 10),
                              // TextInput(
                              //     controller: confirmPasswordController,
                              //     hint: 'Confirm Password',
                              //     icon: 'password',
                              //     obscureText: true),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                        SubmitButton(
                            title: 'SIGN UP',
                            onPressed: () {
                              signUp();
                            }),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         "Already have a account?",
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           Navigator.pop(context);
                  //         },
                  //         style: ButtonStyle(
                  //           splashFactory: NoSplash.splashFactory,
                  //         ),
                  //         child: Text(
                  //           'Sign in',
                  //           style: TextStyle(color: Colors.yellow),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
