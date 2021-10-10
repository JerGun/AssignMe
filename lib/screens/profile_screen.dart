import 'package:flutter/material.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthenticationService>().signOutWithGoogle().then((value) => Navigator.pop(context));
              },
              icon: Icon(Icons.exit_to_app)),
        ],
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
