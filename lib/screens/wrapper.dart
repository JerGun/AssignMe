import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/sign_up/sign_up_screen.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';
import 'sign_in/sign_in_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    var role;

    if (firebaseUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        print('Role: ${documentSnapshot['role']}');
        role = documentSnapshot['role'];
      });
      print(role);
      if (role != 'new') {
        return HomeScreen();
      } else {
        return SignUpScreen();
      }
    }
    return SignInScreen();
  }
}
