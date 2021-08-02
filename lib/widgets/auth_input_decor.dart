import 'package:flutter/material.dart';

InputDecoration textInputDecor(String hint) {
  return InputDecoration(
    hintText: hint,
    enabledBorder: borderOutlineStyle(Colors.grey, 12),
    focusedBorder: borderOutlineStyle(Colors.grey, 12),
    errorBorder: borderOutlineStyle(Colors.redAccent, 12),
    focusedErrorBorder: borderOutlineStyle(Colors.grey, 12),
    filled: true,
    fillColor: Colors.grey[100],
  );
}

OutlineInputBorder borderOutlineStyle(Color borderColor, double circularRadius) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: borderColor,),
    borderRadius: BorderRadius.circular(circularRadius),
  );
}