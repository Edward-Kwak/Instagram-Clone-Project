import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';
import 'package:flutter_code_split/widgets/profile_body.dart';

enum MenuStatus {opened, closed}

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MenuStatus _menuStatus = MenuStatus.closed;
  final menuWidth = size!.width * 2 / 3;
  double bodyXPos = 0;
  double menuXPos = size!.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
          children: [
            AnimatedContainer(
                duration: common_animation_duration,
                curve: Curves.fastOutSlowIn,
                transform: Matrix4.translationValues(bodyXPos, 0, 0),
                child: ProfileBody(onMenuChanged: () {
                  setState(() {
                    _menuStatus = (_menuStatus == MenuStatus.closed) ? MenuStatus.opened : MenuStatus.closed;

                    switch (_menuStatus) {
                      case MenuStatus.opened:
                        bodyXPos -= menuWidth;
                        menuXPos -= menuWidth;
                        break;
                      case MenuStatus.closed:
                        bodyXPos = 0;
                        menuXPos = size!.width;
                        break;
                    }
                  });
                }),
            ),
            AnimatedContainer(
                duration: common_animation_duration,
                curve: Curves.fastOutSlowIn,
                transform: Matrix4.translationValues(menuXPos, 0, 0),
                child: Container(
                  width:menuWidth,
                  color: Colors.blue,
                )
            )
          ]
      ),
    );
  }
}
