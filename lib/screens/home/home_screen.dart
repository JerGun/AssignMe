import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/assignments/add_assignment_screen.dart';
import 'package:flutter_assignme/screens/attach_file_screen.dart';
import 'package:flutter_assignme/screens/groups/join_group_screen.dart';
import 'package:flutter_assignme/screens/home/components/home.dart';
import 'package:flutter_assignme/screens/components/settings_option.dart';
import 'package:flutter_assignme/screens/members/members_screen.dart';
import 'package:flutter_assignme/screens/notifications/components/notifications_button.dart';
import 'package:flutter_assignme/screens/home/components/group_button.dart';
import 'package:flutter_assignme/screens/profile_screen.dart';
import '../components/behavior.dart';
import '../groups/create_group_screen.dart';
import 'components/channel_option_button.dart';
import '../notifications/notifications_screen.dart';

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
  String gid = '';
  String groupName = 'Notifications';
  String cid = '';
  String channelName = 'Welcome to AssignMe';
  String selectedGroupID = '';
  bool isLeftCollapsed = true;
  bool isRightCollapsed = true;
  String previousWidget = 'mid';
  int numberMembers = 0;
  String img = '';
  String owner = '';
  String userRole = '';

  late List<Widget> _children;

  User? user = FirebaseAuth.instance.currentUser;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future deleteGroup(String gid) async {
    FirebaseFirestore.instance.collection('groups').doc(gid).delete();
    CollectionReference collection = FirebaseFirestore.instance.collection('channels');
    await collection
        .where('gid', isEqualTo: gid)
        .get()
        .then((value) => {
              for (QueryDocumentSnapshot snapshot in value.docs) {FirebaseFirestore.instance.collection('channels').doc(snapshot.id).delete()}
            })
        .then((value) => {Navigator.pop(context), Navigator.pop(context)});

    setState(() {
      groupName = 'Notifications';
      groupSelectedIndex = 0;
    });
  }

  Future deleteChannel(String cid) async {
    FirebaseFirestore.instance.collection('channels').doc(cid).delete().then((value) => {Navigator.pop(context), Navigator.pop(context)});
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
    _children = [
      Stack(
        children: [
          Container(
            child: !isLeftCollapsed || previousWidget == 'left'
                ? Container(
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
                              stream: FirebaseFirestore.instance.collection('groups').where('members', arrayContains: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
                                      builder: (context, userSnapshot) {
                                        return ListView.builder(
                                          itemCount: snapshot.data!.docs.length + 2,
                                          itemBuilder: (context, index) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            Map<String, dynamic> user = userSnapshot.data!.data() as Map<String, dynamic>;
                                            return index == 0
                                                ? NotificationButton(
                                                    groupName: groupName,
                                                    groupSelectedIndex: groupSelectedIndex,
                                                    index: index,
                                                    onPressed: () {
                                                      setState(() {
                                                        groupSelectedIndex = index;
                                                        groupName = 'Notifications';
                                                        channelName = 'Welcome to AssignMe';
                                                      });
                                                    })
                                                : index == snapshot.data!.docs.length + 1
                                                    ? Column(
                                                        children: [
                                                          Container(
                                                            width: 55,
                                                            height: 55,
                                                            child: ElevatedButton(
                                                              onPressed: () async {
                                                                if (user['role'] == 'teacher') {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => CreateGroupScreen()),
                                                                  ).then((value) => setState(() {
                                                                        groupName = 'Notifications';
                                                                        groupSelectedIndex = 0;
                                                                      }));
                                                                } else {
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => JoinGroupScreen())).then((value) => setState(() {
                                                                        groupName = 'Notifications';
                                                                        groupSelectedIndex = 0;
                                                                      }));
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  shape: new RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(40),
                                                                  ),
                                                                  primary: Colors.grey[800]),
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors.yellow,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                        ],
                                                      )
                                                    : GroupButton(
                                                        groupName: snapshot.data!.docs[index - 1].get('groupName'),
                                                        img: snapshot.data!.docs[index - 1].get('img'),
                                                        groupSelectedIndex: groupSelectedIndex,
                                                        index: index,
                                                        onPressed: () {
                                                          setState(() {
                                                            userRole = user['role'];
                                                            groupSelectedIndex = index;
                                                            groupName = snapshot.data!.docs[index - 1].get('groupName');
                                                            gid = snapshot.data!.docs[index - 1].get('gid');
                                                            numberMembers = snapshot.data!.docs[index - 1].get('members').length;
                                                            img = snapshot.data!.docs[index - 1].get('img');
                                                            owner = snapshot.data!.docs[index - 1].get('owner');
                                                          });
                                                        },
                                                      );
                                          },
                                        );
                                      });
                                }
                              },
                            ),
                          ),
                        ),
                        groupName == 'Notifications'
                            ? NotificationsScreen(uid: user!.uid)
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.625,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.grey[850],
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.grey[850],
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
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      color: Colors.grey[850],
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 40,
                                                                  backgroundColor: img != '' ? Colors.transparent : Colors.yellow,
                                                                  backgroundImage: NetworkImage(img),
                                                                  child: img != ''
                                                                      ? Container()
                                                                      : Text(
                                                                          groupName.substring(0, 2).toUpperCase(),
                                                                          style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 18,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                ),
                                                                SizedBox(height: 20),
                                                                Text(
                                                                  groupName,
                                                                  style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10),
                                                                Text(
                                                                  '${numberMembers.toString()} Members',
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(20),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey[800],
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: owner == user!.uid
                                                                        ? Column(
                                                                            children: [
                                                                              SettingsOption(
                                                                                title: 'Group Settings',
                                                                                icon: Icons.settings,
                                                                                onPressed: () {},
                                                                              ),
                                                                              SettingsOption(
                                                                                title: 'Delete Group',
                                                                                icon: Icons.close,
                                                                                color: Colors.red,
                                                                                onPressed: () {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return AlertDialog(
                                                                                        title: Text(
                                                                                          "Delete '$groupName'",
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                        content: Text(
                                                                                          'Are you sure you want to delete $groupName? \nThis action cannot be undone.',
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                            fontSize: 14,
                                                                                          ),
                                                                                        ),
                                                                                        backgroundColor: Colors.grey[800],
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Text(
                                                                                              'Cancle',
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 100,
                                                                                            height: 40,
                                                                                            decoration: BoxDecoration(
                                                                                              color: Colors.red,
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            child: TextButton(
                                                                                              onPressed: () async {
                                                                                                deleteGroup(gid);
                                                                                              },
                                                                                              child: Text(
                                                                                                'Confirm',
                                                                                                style: TextStyle(
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Column(
                                                                            children: [
                                                                              SettingsOption(
                                                                                title: 'Leave Group',
                                                                                icon: Icons.exit_to_app,
                                                                                color: Colors.red,
                                                                                onPressed: () {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return AlertDialog(
                                                                                        title: Text(
                                                                                          "Leave '$groupName'",
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                        content: Text(
                                                                                          'Are you sure you want to leave $groupName?.',
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                            fontSize: 14,
                                                                                          ),
                                                                                        ),
                                                                                        backgroundColor: Colors.grey[800],
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Text(
                                                                                              'Cancle',
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 100,
                                                                                            height: 40,
                                                                                            decoration: BoxDecoration(
                                                                                              color: Colors.red,
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            child: TextButton(
                                                                                              onPressed: () async {
                                                                                                deleteGroup(gid);
                                                                                              },
                                                                                              child: Text(
                                                                                                'Confirm',
                                                                                                style: TextStyle(
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
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
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('channels').where('gid', isEqualTo: gid).snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            } else {
                                              return ListView.builder(
                                                itemCount: snapshot.data!.docs.length + 1,
                                                itemBuilder: (context, index) {
                                                  return index == 0
                                                      ? ChannelOptionButton(
                                                          gid: gid,
                                                          groupName: groupName,
                                                        )
                                                      : Container(
                                                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: (snapshot.data!.docs[index - 1].get('channelName') == channelName && snapshot.data!.docs[index - 1].get('gid') == selectedGroupID)
                                                                ? Colors.grey[700]
                                                                : Colors.grey[850],
                                                          ),
                                                          height: 40,
                                                          child: TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                cid = snapshot.data!.docs[index - 1].get('cid');
                                                                channelName = snapshot.data!.docs[index - 1].get('channelName');
                                                                selectedGroupID = snapshot.data!.docs[index - 1].get('gid');
                                                                isLeftCollapsed = !isLeftCollapsed;
                                                              });
                                                            },
                                                            onLongPress: () {
                                                              showModalBottomSheet(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return Container(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    color: Colors.grey[850],
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CircleAvatar(
                                                                                radius: 40,
                                                                                backgroundColor: img != '' ? Colors.transparent : Colors.yellow,
                                                                                backgroundImage: NetworkImage(img),
                                                                                child: img != ''
                                                                                    ? Container()
                                                                                    : Text(
                                                                                        snapshot.data!.docs[index - 1].get('channelName').substring(0, 2).toUpperCase(),
                                                                                        style: TextStyle(
                                                                                          color: Colors.black,
                                                                                          fontSize: 18,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                              SizedBox(height: 20),
                                                                              Text(
                                                                                snapshot.data!.docs[index - 1].get('channelName'),
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10),
                                                                              Text(
                                                                                '${numberMembers.toString()} Members',
                                                                                style: TextStyle(
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.all(20),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.grey[800],
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  child: owner == user!.uid
                                                                                      ? Column(
                                                                                          children: [
                                                                                            SettingsOption(
                                                                                              title: 'Channel Settings',
                                                                                              icon: Icons.settings,
                                                                                              onPressed: () {},
                                                                                            ),
                                                                                            SettingsOption(
                                                                                              title: 'Delete Channel',
                                                                                              icon: Icons.close,
                                                                                              color: Colors.red,
                                                                                              onPressed: () {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (context) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text(
                                                                                                        "Delete '${snapshot.data!.docs[index - 1].get('channelName')}'",
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.white,
                                                                                                        ),
                                                                                                      ),
                                                                                                      content: Text(
                                                                                                        'Are you sure you want to delete ${snapshot.data!.docs[index - 1].get('channelName')}? \nThis action cannot be undone.',
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.white,
                                                                                                          fontSize: 14,
                                                                                                        ),
                                                                                                      ),
                                                                                                      backgroundColor: Colors.grey[800],
                                                                                                      actions: [
                                                                                                        TextButton(
                                                                                                          onPressed: () {
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          child: Text(
                                                                                                            'Cancle',
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.white,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Container(
                                                                                                          width: 100,
                                                                                                          height: 40,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: Colors.red,
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                          ),
                                                                                                          child: TextButton(
                                                                                                            onPressed: () async {
                                                                                                              deleteChannel(snapshot.data!.docs[index - 1].get('cid'));
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              'Confirm',
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.white,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : Column(
                                                                                          children: [
                                                                                            SettingsOption(
                                                                                              title: 'Leave Channel',
                                                                                              icon: Icons.exit_to_app,
                                                                                              color: Colors.red,
                                                                                              onPressed: () {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (context) {
                                                                                                    return AlertDialog(
                                                                                                      title: Text(
                                                                                                        "Leave '${snapshot.data!.docs[index - 1].get('channelName')}'",
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.white,
                                                                                                        ),
                                                                                                      ),
                                                                                                      content: Text(
                                                                                                        'Are you sure you want to leave ${snapshot.data!.docs[index - 1].get('channelName')}?.',
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.white,
                                                                                                          fontSize: 14,
                                                                                                        ),
                                                                                                      ),
                                                                                                      backgroundColor: Colors.grey[800],
                                                                                                      actions: [
                                                                                                        TextButton(
                                                                                                          onPressed: () {
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          child: Text(
                                                                                                            'Cancle',
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.white,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Container(
                                                                                                          width: 100,
                                                                                                          height: 40,
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: Colors.red,
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                          ),
                                                                                                          child: TextButton(
                                                                                                            onPressed: () async {
                                                                                                              deleteChannel(snapshot.data!.docs[index - 1].get('cid'));
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              'Confirm',
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.white,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                snapshot.data!.docs[index - 1].get('channelName'),
                                                                style: TextStyle(
                                                                    color: (snapshot.data!.docs[index - 1].get('channelName') == channelName &&
                                                                            snapshot.data!.docs[index - 1].get('gid') == selectedGroupID)
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
                                            }
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
                  )
                : groupName == 'Notification'
                    ? Container()
                    : MembersScreen(gid: gid, groupName: groupName),
          ),
          AnimatedPositioned(
            duration: duration,
            left: isLeftCollapsed && isRightCollapsed
                ? 0
                : !isLeftCollapsed && isRightCollapsed
                    ? 0.85 * MediaQuery.of(context).size.width
                    : -0.85 * MediaQuery.of(context).size.width,
            right: isLeftCollapsed && isRightCollapsed
                ? 0
                : !isLeftCollapsed && isRightCollapsed
                    ? -0.85 * MediaQuery.of(context).size.width
                    : 0.85 * MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[800],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    color: Colors.grey[850],
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 5),
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(Icons.menu, color: Colors.white),
                            onTap: () {
                              setState(() {
                                if (isLeftCollapsed) {
                                  _pageController.forward();
                                  _bottomNavController.forward();
                                } else {
                                  _pageController.reverse();
                                  _bottomNavController.reverse();
                                }
                                isLeftCollapsed = !isLeftCollapsed;
                                previousWidget = 'left';
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
                          if (groupName != 'Notifications' || userRole != 'teacher')
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AttachFileScreen(
                                              gid: gid,
                                              userRole: userRole,
                                            )));
                              },
                              icon: Icon(Icons.attach_file, color: Colors.white),
                            ),
                          if (groupName != 'Notifications' || userRole != 'teacher')
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddAssignmentScreen(
                                              gid: gid,
                                              groupName: groupName,
                                              cid: cid,
                                              channelName: channelName,
                                            )));
                              },
                              icon: Icon(Icons.assignment, color: Colors.white),
                            ),
                          if (groupName != 'Notifications')
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (isLeftCollapsed) {
                                      _pageController.forward();
                                      _bottomNavController.forward();
                                    } else {
                                      _pageController.reverse();
                                      _bottomNavController.reverse();
                                    }
                                    isRightCollapsed = !isRightCollapsed;
                                    previousWidget = 'right';
                                  });
                                },
                                icon: Icon(Icons.people, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Assignments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Home()
                ],
              ),
            ),
          ),
        ],
      ),
      Container(),
      ProfileScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.grey[900],
        child: SafeArea(child: _children[_selectedIndex]),
      ),
      floatingActionButton: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
        ),
        child: AnimatedBuilder(
          animation: _bottomNavController,
          builder: (context, child) {
            return AnimatedContainer(
              duration: duration,
              width: isLeftCollapsed && isRightCollapsed ? 60 : 0,
              height: isLeftCollapsed && isRightCollapsed ? 60 : 0,
              child: child,
            );
          },
          child: Wrap(
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAssignmentScreen(gid: gid, groupName: groupName, cid: cid, channelName: channelName)));
                },
                child: Icon(
                  Icons.add,
                  color: isLeftCollapsed && isRightCollapsed ? Colors.grey[850] : Colors.transparent,
                ),
                backgroundColor: Colors.yellow,
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
              height: isLeftCollapsed ? 0 : 60,
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
                backgroundColor: Colors.black.withOpacity(0.9),
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
                    label: 'Profile',
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
