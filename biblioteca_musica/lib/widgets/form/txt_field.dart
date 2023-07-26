import 'package:flutter/material.dart';

class _TxtFieldDecoration extends InputDecoration {
  const _TxtFieldDecoration()
      : super(
            isCollapsed: true,
            errorStyle: const TextStyle(fontSize: 10),
            contentPadding: const EdgeInsets.all(10),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)));
}

class TextFormFieldCustom extends TextFormField {
  TextFormFieldCustom(String texto, void Function(String nuevo) onChanged,
      {super.key})
      : super(
            initialValue: texto,
            decoration: const _TxtFieldDecoration(),
            onChanged: onChanged);
}

class TextFieldCustom extends TextField {
  TextFieldCustom(String texto, void Function(String nuevo) onChanged,
      {super.key})
      : super(
            controller: TextEditingController(text: texto),
            decoration: const _TxtFieldDecoration(),
            onChanged: onChanged);
}
