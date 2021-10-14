import 'package:flutter/material.dart';

class GroupButton extends StatelessWidget {
  const GroupButton({
    Key? key,
    required this.groupName,
    required this.img,
    required this.groupSelectedIndex,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  final String groupName;
  final String img;
  final int groupSelectedIndex;
  final int index;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: groupSelectedIndex == index ? BorderRadius.circular(20) : BorderRadius.circular(40),
              color: groupSelectedIndex == index ? Colors.yellow : Colors.grey[800],
              image: DecorationImage(
                image: NetworkImage(
                  img,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: TextButton(
                onPressed: onPressed,
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: img != ''
                    ? Container()
                    : Text(
                        groupName.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: groupSelectedIndex == index ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                // SvgPicture.asset(
                //   'assets/icons/group.svg',
                //   color: groupSelectedIndex == index ? Colors.grey[900] : Colors.grey,
                // ),
                ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
