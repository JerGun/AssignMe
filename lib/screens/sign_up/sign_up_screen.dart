import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/submit_button.dart';
import 'package:flutter_assignme/screens/components/text_input.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                              Navigator.pop(context);
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Create Account',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'PLease fill the input blow here.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextInput(
                              controller: fullNameController,
                              hint: 'Full Name',
                              icon: 'person',
                              obscureText: false),
                          SizedBox(height: 10),
                          TextInput(
                              controller: emailController,
                              hint: 'Email',
                              icon: 'email',
                              obscureText: false),
                          SizedBox(height: 10),
                          TextInput(
                              controller: passwordController,
                              hint: 'Password',
                              icon: 'password',
                              obscureText: true),
                          SizedBox(height: 10),
                          TextInput(
                              controller: confirmPasswordController,
                              hint: 'Confirm Password',
                              icon: 'password',
                              obscureText: true),
                          SizedBox(height: 30),
                        ],
                      ),
                      SubmitButton(
                        title: 'SIGN UP',
                        onPressed: () {
                          context
                              .read<AuthenticationService>()
                              .signUpWithEmail(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              )
                              .then((value) async {
                            User? user = FirebaseAuth.instance.currentUser;
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .set({
                              'uid': user.uid,
                              'email': emailController.text.trim(),
                              'password': passwordController.text.trim(),
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have a account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.yellow),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
