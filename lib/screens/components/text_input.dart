import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.controller,
    required this.hint,
    this.enabled = true,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final textInputType;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool isFocus = false;
  int numLines = 0;
  double heightOfContainer = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: heightOfContainer,
      constraints: BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isFocus ? Colors.grey[700] : Colors.grey[850],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              isFocus = hasFocus;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onChanged: (String e) {
                int sizeIncreaseConstant = 24;
                int widthOfCharacter = 17;
                int newNumLines = ((e.length * widthOfCharacter) / MediaQuery.of(context).size.width * 0.8).truncate();
                if (newNumLines != numLines) {
                  setState(() {
                    if (newNumLines > numLines)
                      heightOfContainer = heightOfContainer + sizeIncreaseConstant;
                    else
                      heightOfContainer = heightOfContainer - sizeIncreaseConstant;
                    numLines = newNumLines;
                  });
                }
              },
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: TextStyle(color: isFocus ? Colors.white : Colors.grey),
              ),
              enabled: widget.enabled,
              keyboardType: widget.textInputType,
              style: TextStyle(color: Colors.white),
              maxLines: null,
            ),
          ),
        ),
      ),
    );
  }
}
