import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.icon,
    this.hint = '',
  }) : super(key: key);

  final TextEditingController controller;
  final bool obscureText;
  final String icon;
  final String hint;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isFocus ? Colors.grey[700] : Colors.grey[850],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                isFocus = hasFocus;
              });
            },
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle:
                    TextStyle(color: isFocus ? Colors.white : Colors.grey),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/icons/${widget.icon}.svg',
                    color: isFocus ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: 1,
              obscureText: widget.obscureText,
            ),
          ),
        ),
      ),
    );
  }
}
