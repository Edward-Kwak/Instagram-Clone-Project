import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';
import 'package:flutter_code_split/widgets/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _appbar(),
            ProfileBody(),
        ],),
      ),
    );
  }

  Row _appbar() {
    return Row(children: <Widget>[
      SizedBox(
          width: common_icon_width,
          child: IconButton(
            onPressed: () {  },
            icon: Icon(Icons.arrow_back),)),
      Expanded(child: Text('user', textAlign: TextAlign.center,)),
    ],);
  }



}