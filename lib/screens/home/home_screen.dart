import 'package:flutter/material.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("HOME"),
        TextButton(
          onPressed: () {
            context.read<AuthenticationService>().signOutWithGoogle();
          },
          child: Text("Sign out"),
        ),
      ],
    ));
  }
}
