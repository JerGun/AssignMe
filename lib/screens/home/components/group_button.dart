import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GroupButton extends StatelessWidget {
  const GroupButton({
    Key? key,
    required this.groupSelectedIndex,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

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
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: groupSelectedIndex == index ? BorderRadius.circular(20) : BorderRadius.circular(40),
                ),
                primary: groupSelectedIndex == index ? Colors.yellow : Colors.grey[800]),
            child: SvgPicture.asset(
              'assets/icons/group.svg',
              color: groupSelectedIndex == index ? Colors.grey[900] : Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}