import 'package:flutter/material.dart';

import '../../groups/create_group_screen.dart';

class CreateGroupButton extends StatelessWidget {
  const CreateGroupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          child: ElevatedButton(
            onPressed: () async{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroupScreen()),
              );
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
    );
  }
}