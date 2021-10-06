import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/components/behavior.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height,
              child: ScrollConfiguration(
                behavior: Behavior(),
                child: ListView.builder(
                  itemCount: 1 + 10,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Column(
                            children: [
                              SizedBox(height: 20),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.grey[800]),
                                child: Icon(
                                  Icons.chat_bubble,
                                  color: Colors.grey,
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
                        : Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.grey[800]),
                                child: Icon(
                                  Icons.chat_bubble,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                  },
                ),
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Team',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            print('object');
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[700],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Center(
                                        child: Text(
                                          'Invite Members',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          splashFactory: NoSplash.splashFactory,
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'CHANNELS',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[700],
                                ),
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'General $index',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
