import 'package:flutter/material.dart';

Container toast(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.grey.withOpacity(0.5),
    ),
    child: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
  );
}
