import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    Key? key,
    required this.groupName,
    required this.groupSelectedIndex,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  final String groupName;
  final int groupSelectedIndex;
  final int index;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: 55,
          height: 55,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: groupSelectedIndex == index || groupName == 'Notifications' ? BorderRadius.circular(20) : BorderRadius.circular(40),
                ),
                primary: groupSelectedIndex == index || groupName == 'Notifications' ? Colors.yellow : Colors.grey[800]),
            child: Icon(
              Icons.notifications,
              color: groupSelectedIndex == index || groupName == 'Notifications' ? Colors.grey[900] : Colors.grey,
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
    );
  }
}
