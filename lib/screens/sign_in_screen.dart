import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/submit_button.dart';
import 'package:flutter_assignme/screens/components/text_input.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'components/behavior.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: Behavior(),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[850],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.10,
                          bottom: MediaQuery.of(context).size.height * 0.06),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Login',
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
                              'PLease sign in to continue.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 30),
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
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SubmitButton(
                      title: 'Sign in',
                      onPressed: () {
                        // context.read<AuthenticationService>().signInWithEmail(
                        //     email: emailController.text.trim(),
                        //     password: passwordController.text.trim());
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Or',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AuthenticationService>()
                            .signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.65, 55),
                          primary: Colors.yellow),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child:
                                  SvgPicture.asset('assets/icons/google.svg'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(
                                color: Colors.grey[850],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Container(
                //   margin: EdgeInsets.only(bottom: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Don't have an account?",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //       TextButton(
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => SignUpScreen()),
                //           );
                //         },
                //         style: ButtonStyle(
                //           splashFactory: NoSplash.splashFactory,
                //         ),
                //         child: Text(
                //           'Sign up',
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
