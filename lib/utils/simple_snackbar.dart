import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void SimpleSnackBar (BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
}