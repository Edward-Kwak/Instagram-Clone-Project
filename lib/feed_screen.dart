import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
              'instagram',
              style: TextStyle(fontFamily: 'VeganStyle', color: Colors.black),)),)
      ,);
  }
}
