import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:make_feed_screen/constants/screen_size.dart';
import 'package:make_feed_screen/models/firestore/user_model_state.dart';
import 'package:make_feed_screen/screens/camera_screen.dart';
import 'package:make_feed_screen/screens/feed_screen.dart';
import 'package:make_feed_screen/screens/profile_screen.dart';
import 'package:make_feed_screen/screens/search_screen.dart';
import 'package:make_feed_screen/widgets/my_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home, size: 24.0, ), label: '', backgroundColor: Colors.grey[200],),
    BottomNavigationBarItem(icon: Icon(Icons.search, size: 24.0, ), label: '', backgroundColor: Colors.grey[200],),
    BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 24.0, ), label: '',backgroundColor: Colors.grey[200],),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined, size: 24.0, ), label: '',backgroundColor: Colors.grey[200], ),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 24.0, ), label: '', backgroundColor: Colors.grey[200],),
  ];

  int _selectedIndex = 0;

  static List<Widget> _screens = <Widget>[
    Consumer<UserModelState>(
      builder: (context, userModelState, child) {
        if (userModelState == null
        || userModelState.userModel == null
        || userModelState.userModel!.followings == null
        || userModelState.userModel!.followings.isEmpty) {
          return MyProgressIndicator();
        }
        else {
          return FeedScreen(userModelState.userModel!.followings);
        }
      },
    ),
    SearchScreen(),
    Container(color: Colors.red),
    MyProgressIndicator(),
    // Container(color: Colors.grey[300]),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:btmNavItems,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black45,
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onBtmItemClick,
      ),
    );
  }

  void _onBtmItemClick(int index) {
    switch (index) {
      case 2:
        _openCamera();
        break;

      default:
        print(index);
        setState(() {
          _selectedIndex = index;
        });
        break;
    }
  }

  void _openCamera() async {
    if (await checkIfPermissionGranted(context)) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CameraScreen())
      );
    } else {
      SnackBar popUp = SnackBar(
        content: Text('카메라, 마이크 접근 허용을 해주셔야 이용 가능합니다.'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () { 
            _scaffoldKey.currentState!.hideCurrentSnackBar();
            AppSettings.openAppSettings();
          },
        ),
      );
      
      _scaffoldKey.currentState!.showSnackBar(popUp);
    }
  }

  Future<bool> checkIfPermissionGranted(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Platform.isIOS ? Permission.photos : Permission.storage,
      // Permission.accessMediaLocation,
      // Permission.manageExternalStorage,
      ].request();

    bool permitted = true;

    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted)        permitted = false;
    });

    return permitted;
  }


}

