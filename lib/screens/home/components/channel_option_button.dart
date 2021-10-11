import 'package:flutter/material.dart';
import 'package:flutter_assignme/screens/invite_members_screen.dart';

import '../../create_channel_screen.dart';

class ChannelOptionButton extends StatelessWidget {
  const ChannelOptionButton({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  final String groupID;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 0,
                offset: Offset(0, 5),
              ),
            ],
            color: Colors.grey[700],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InviteMemberScreen(groupID: groupID)),
              );
            },
            child: Center(
              child: Text(
                'Invite Members',
                style: TextStyle(color: Colors.white),
              ),
            ),
            style: ElevatedButton.styleFrom(splashFactory: NoSplash.splashFactory, primary: Colors.grey[700]),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CHANNELS',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateChannelScreen(groupID: groupID)),
                  );
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
    );
  }
}
