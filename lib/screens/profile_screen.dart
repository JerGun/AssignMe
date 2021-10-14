import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/edit_profile_screen.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow)),
          );
        }
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Colors.grey[900],
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'User Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AuthenticationService>().signOutWithGoogle();
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[850],
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(data['img']),
                            child: data['img'] != ''
                                ? Container()
                                : Text(
                                    '${data['firstName'][0].toUpperCase()}${data['firstName'][0].toUpperCase()}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                '${data['firstName']} ${data['lastName']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '#${data['tag']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            data['role'] == 'teacher' ? 'T${data['role'].toString().substring(1)}' : 'S${data['role'].toString().substring(1)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                      img: data['img'],
                                      firstName: data['firstName'],
                                      lastName: data['lastName'],
                                    )));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[850],
                              ),
                            ),
                            SizedBox(width: 30),
                            Text(
                              'My Account',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
