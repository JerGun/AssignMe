import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';
import 'package:flutter_assignme/screens/create_group.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int groupSelectedIndex = 0;
  String groupName = 'Direct Messages';

  @override
  Widget build(BuildContext context) {
    return 
  }
}
