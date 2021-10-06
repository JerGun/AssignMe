import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/submit_button.dart';
import 'package:flutter_assignme/screens/components/text_input.dart';
import 'package:flutter_assignme/screens/home/home_screen.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String role = 'teacher';
  bool firstNameError = false;
  bool lastNameError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              context
                                  .read<AuthenticationService>()
                                  .signOutWithGoogle();
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
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'PLease fill the input blow here.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: role == 'teacher'
                                          ? Colors.yellow
                                          : Colors.grey[800]),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        role = 'teacher';
                                      });
                                    },
                                    child: Text(
                                      'Teacher',
                                      style: TextStyle(
                                          color: role == 'teacher'
                                              ? Colors.black
                                              : Colors.grey),
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
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: role == 'student'
                                          ? Colors.yellow
                                          : Colors.grey[800]),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        role = 'student';
                                      });
                                    },
                                    child: Text(
                                      'Student',
                                      style: TextStyle(
                                          color: role == 'student'
                                              ? Colors.black
                                              : Colors.grey),
                                    ),
                                    style: ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            TextInput(
                                controller: firstNameController,
                                hint: 'First Name',
                                icon: 'person',
                                obscureText: false),
                            SizedBox(height: 10),
                            TextInput(
                                controller: lastNameController,
                                hint: 'Last Name',
                                icon: 'person',
                                obscureText: false),
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
                          onPressed: () async {
                            User? user = FirebaseAuth.instance.currentUser;
                            firstNameController.text == ''
                                ? firstNameError = true
                                : lastNameController.text == ''
                                    ? lastNameError = true
                                    : await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .update({
                                        'role': role,
                                        'firstName': firstNameController.text,
                                        'lastName': lastNameController.text
                                      }).then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen())));
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
    );
  }
}