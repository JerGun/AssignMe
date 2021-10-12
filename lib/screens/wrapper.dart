import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';
import 'sign_in_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      return FutureBuilder<DocumentSnapshot>(
        future: users.doc(firebaseUser.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['role'] == 'new') return SignUpScreen();
          return HomeScreen();
        },
      );
    }
    return SignInScreen();
  }
}
