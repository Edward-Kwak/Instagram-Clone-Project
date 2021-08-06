import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/screen_size.dart';
import 'package:make_feed_screen/widgets/profile_body.dart';
import 'package:make_feed_screen/widgets/profile_side_menu.dart';

const duration = Duration(milliseconds: 300);
const icon_duration = Duration(milliseconds: 1000);


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
          children: <Widget>[
            AnimatedContainer(
              duration: duration,
              curve: Curves.fastOutSlowIn,
              child: ProfileBody(
                  onMenuChanged: () {
                    setState(() {
                      _menuStatus = (_menuStatus == MenuStatus.closed) ? MenuStatus.opened : MenuStatus.closed;
                      print("menuClicked");
                      print(_menuStatus);

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
              transform: Matrix4.translationValues(bodyXPos, 0, 0),
            ),
            AnimatedContainer(
                duration: duration,
                curve: Curves.fastOutSlowIn,
                transform: Matrix4.translationValues(menuXPos, 0, 0),
                child: ProfileSideMenu(menuWidth),

                /*    Positioned 쓰면 Incorrect use of ParentDataWidget. 에러 발생. 그냥 Container가 날듯.
                child: Positioned(
                  top: 0,
                  bottom: 0,
                  width: menuWidth,
                  child: Container(
                    color: Colors.purpleAccent,),
                )
                */
            ),
          ])
    );
  }
}
