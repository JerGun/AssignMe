import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/assignment_screen.dart';
import 'package:flutter_assignme/screens/create_message_screen.dart';
import 'package:flutter_assignme/screens/home/components/create_group_button.dart';
import 'package:flutter_assignme/screens/home/components/direct_messages_button.dart';
import 'package:flutter_assignme/screens/home/components/group_button.dart';
import 'package:flutter_assignme/screens/profile_screen.dart';
import 'package:flutter_assignme/services/authentication_service.dart';
import 'package:provider/provider.dart';

import '../components/behavior.dart';
import 'components/channel_option_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Duration duration = const Duration(milliseconds: 300);

  late AnimationController _pageController;
  late AnimationController _bottomNavController;

  int _selectedIndex = 0;
  int groupSelectedIndex = 0;
  String groupName = 'Direct Messages';
  String channelName = 'General';
  String selectedGroupID = '';
  String groupID = '';
  bool isCollapsed = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentScreen()));
          break;
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
          break;
        default:
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(vsync: this, duration: duration);
    _bottomNavController = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bottomNavController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                              .where('owners', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data!.docs.length + 2,
                                    itemBuilder: (context, index) {
                                      return index == 0
                                          ? DirectMessagesButton(
                                              groupSelectedIndex: groupSelectedIndex,
                                              index: index,
                                              onPressed: () {
                                                setState(() {
                                                  groupSelectedIndex = index;
                                                  groupName = 'Direct Messages';
                                                });
                                              })
                                          : index == snapshot.data!.docs.length + 1
                                              ? CreateGroupButton()
                                              : GroupButton(
                                                  groupSelectedIndex: groupSelectedIndex,
                                                  index: index,
                                                  onPressed: () {
                                                    setState(() {
                                                      groupSelectedIndex = index;
                                                      groupName = snapshot.data!.docs[index - 1].get('name');
                                                      groupID = snapshot.data!.docs[index - 1].get('gid');
                                                    });
                                                  },
                                                );
                                    },
                                  );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.625,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[800],
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey[800],
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
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
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => CreateMessageScreen()));
                                    },
                                    icon: groupName == 'Direct Messages'
                                        ? Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          )
                                        : Icon(
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
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('channels')
                                    .where('group', isEqualTo: groupID)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return !snapshot.hasData
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          itemCount: snapshot.data!.docs.length + 1,
                                          itemBuilder: (context, index) {
                                            return groupName == 'Direct Messages'
                                                ? Container()
                                                : index == 0
                                                    ? ChannelOptionButton(groupID: groupID)
                                                    : Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: (snapshot.data!.docs[index - 1].get('name') ==
                                                                      channelName &&
                                                                  snapshot.data!.docs[index - 1].get('group') ==
                                                                      selectedGroupID)
                                                              ? Colors.grey[700]
                                                              : Colors.grey[800],
                                                        ),
                                                        height: 40,
                                                        child: TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              channelName = snapshot.data!.docs[index - 1].get('name');
                                                              selectedGroupID =
                                                                  snapshot.data!.docs[index - 1].get('group');
                                                              isCollapsed = !isCollapsed;
                                                            });
                                                          },
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              snapshot.data!.docs[index - 1].get('name'),
                                                              style: TextStyle(
                                                                  color: (snapshot.data!.docs[index - 1].get('name') ==
                                                                              channelName &&
                                                                          snapshot.data!.docs[index - 1].get('group') ==
                                                                              selectedGroupID)
                                                                      ? Colors.white
                                                                      : Colors.grey),
                                                            ),
                                                          ),
                                                          style: ButtonStyle(
                                                            splashFactory: NoSplash.splashFactory,
                                                          ),
                                                        ),
                                                      );
                                          },
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
                left: isCollapsed ? 0 : 0.85 * MediaQuery.of(context).size.width,
                right: isCollapsed ? 0 : -0.85 * MediaQuery.of(context).size.width,
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
                                    if (isCollapsed) {
                                      _pageController.forward();
                                      _bottomNavController.forward();
                                    } else {
                                      _pageController.reverse();
                                      _bottomNavController.reverse();
                                    }
                                    isCollapsed = !isCollapsed;
                                  });
                                },
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    channelName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                          context.read<AuthenticationService>().signOutWithGoogle();
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
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
        ),
        child: AnimatedBuilder(
          animation: _bottomNavController,
          builder: (context, child) {
            return AnimatedContainer(
              duration: duration,
              height: isCollapsed ? 0 : 60,
              child: child,
            );
          },
          child: Wrap(
            children: [
              BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 30,
                selectedItemColor: Colors.yellow,
                unselectedItemColor: Colors.grey[700],
                backgroundColor: Colors.grey[900],
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'People',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Person',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
