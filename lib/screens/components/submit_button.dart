import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          fixedSize: Size(MediaQuery.of(context).size.width * 0.45, 55),
          primary: Colors.yellow),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey[850], fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
