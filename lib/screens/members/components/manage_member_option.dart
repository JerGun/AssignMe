import 'package:flutter/material.dart';

class ManageMembersOption extends StatelessWidget {
  const ManageMembersOption({
    Key? key,
    required this.title,
    required this.icon,
    this.color = Colors.grey,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final icon;
  final color;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
