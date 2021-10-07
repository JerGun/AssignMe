import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/friend_screen.dart';
import 'package:flutter_assignme/screens/profile_screen.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

import 'components/behavior.dart';
import 'create_group.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Duration duration = const Duration(milliseconds: 300);

  late AnimationController _controller;

  int _selectedIndex = 0;
  int groupSelectedIndex = 0;
  String groupName = 'Direct Messages';
  bool isCollapsed = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedIndex == 1
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendScreen()),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height,
                        child: ScrollConfiguration(
                          behavior: Behavior(),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('groups')
                                  .where('owners',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return !snapshot.hasData
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            snapshot.data!.docs.length + 2,
                                        itemBuilder: (context, index) {
                                          return index == 0
                                              ? Column(
                                                  children: [
                                                    SizedBox(height: 20),
                                                    Container(
                                                      width: 55,
                                                      height: 55,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            groupSelectedIndex =
                                                                index;
                                                            groupName =
                                                                'Direct Messages';
                                                          });
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    new RoundedRectangleBorder(
                                                                  borderRadius: groupSelectedIndex ==
                                                                          index
                                                                      ? BorderRadius
                                                                          .circular(
                                                                              20)
                                                                      : BorderRadius
                                                                          .circular(
                                                                              40),
                                                                ),
                                                                primary: groupSelectedIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .yellow
                                                                    : Colors.grey[
                                                                        800]),
                                                        child: Icon(
                                                          Icons.chat_bubble,
                                                          color:
                                                              groupSelectedIndex ==
                                                                      index
                                                                  ? Colors
                                                                      .grey[900]
                                                                  : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Divider(
                                                        height: 20,
                                                        thickness: 1,
                                                        indent: 20,
                                                        endIndent: 20,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : index ==
                                                      snapshot.data!.docs
                                                              .length +
                                                          1
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                          width: 55,
                                                          height: 55,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              CreateGroupScreen()),
                                                                );
                                                              });
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    shape:
                                                                        new RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40),
                                                                    ),
                                                                    primary: Colors
                                                                            .grey[
                                                                        800]),
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.yellow,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        Container(
                                                          width: 55,
                                                          height: 55,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                groupSelectedIndex =
                                                                    index;
                                                                groupName = snapshot
                                                                    .data!
                                                                    .docs[
                                                                        index -
                                                                            1]
                                                                    .get(
                                                                        'name');
                                                              });
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    shape:
                                                                        new RoundedRectangleBorder(
                                                                      borderRadius: groupSelectedIndex ==
                                                                              index
                                                                          ? BorderRadius.circular(
                                                                              20)
                                                                          : BorderRadius.circular(
                                                                              40),
                                                                    ),
                                                                    primary: groupSelectedIndex ==
                                                                            index
                                                                        ? Colors
                                                                            .yellow
                                                                        : Colors
                                                                            .grey[800]),
                                                            child: Icon(
                                                              Icons.chat_bubble,
                                                              color: groupSelectedIndex ==
                                                                      index
                                                                  ? Colors
                                                                      .grey[900]
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    );
                                        });
                              }),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.625,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[800],
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.05),
                              //     spreadRadius: 1,
                              //     blurRadius: 0,
                              //     offset: Offset(0, 3),
                              //   ),
                              // ],
                              color: Colors.grey[800],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      groupName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      print(FirebaseAuth
                                          .instance.currentUser!.uid);
                                    },
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: Behavior(),
                              child: ListView.builder(
                                itemCount: 1 + 15,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Column(
                                          children: [
                                            SizedBox(height: 20),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    spreadRadius: 2,
                                                    blurRadius: 0,
                                                    offset: Offset(0, 5),
                                                  ),
                                                ],
                                                color: Colors.grey[700],
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                child: Center(
                                                  child: Text(
                                                    'Invite Members',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    splashFactory:
                                                        NoSplash.splashFactory,
                                                    primary: Colors.grey[700]),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                                right: 10,
                                                top: 10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'CHANNELS',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      print('asd');
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey[700],
                                          ),
                                          height: 40,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                'General $index',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: duration,
                left:
                    isCollapsed ? 0 : 0.85 * MediaQuery.of(context).size.width,
                right:
                    isCollapsed ? 0 : -0.85 * MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[800],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        color: Colors.grey[850],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                child: Icon(Icons.menu, color: Colors.white),
                                onTap: () {
                                  setState(() {
                                    if (isCollapsed)
                                      _controller.forward();
                                    else
                                      _controller.reverse();
                                    isCollapsed = !isCollapsed;
                                  });
                                },
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Flexible(
                                    child: Text(
                                      groupName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Icon(Icons.attach_file, color: Colors.white),
                              SizedBox(width: 20),
                              Icon(Icons.assignment, color: Colors.white),
                              SizedBox(width: 20),
                              Icon(Icons.people, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      Text("HOME"),
                      TextButton(
                        onPressed: () {
                          context
                              .read<AuthenticationService>()
                              .signOutWithGoogle();
                        },
                        child: Text("Sign out"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Theme(
      //   data: ThemeData(
      //     splashColor: Colors.transparent,
      //   ),
      //   child: BottomNavigationBar(
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     iconSize: 30,
      //     selectedItemColor: Colors.yellow,
      //     unselectedItemColor: Colors.grey[700],
      //     backgroundColor: Colors.grey[900],
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //         ),
      //         label: 'Home',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.people),
      //         label: 'People',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: 'Person',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     onTap: _onItemTapped,
      //   ),
      // ),
    );
  }
}
