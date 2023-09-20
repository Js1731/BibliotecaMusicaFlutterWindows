import 'package:flutter/material.dart';

class CustomTxtFieldDecoration extends InputDecoration {
  const CustomTxtFieldDecoration({String? hint})
      : super(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            isCollapsed: true,
            errorStyle: const TextStyle(fontSize: 10),
            contentPadding: const EdgeInsets.all(10),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)));
}
