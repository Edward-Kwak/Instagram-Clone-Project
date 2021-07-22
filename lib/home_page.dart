import 'package:flutter/material.dart';
import 'package:flutter_code_split/constants/common_vars.dart';
import 'package:flutter_code_split/screens/feed_screen.dart';
import 'package:flutter_code_split/screens/profile_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home, size: common_padding_l, color: Colors.orange), label: '', backgroundColor: Colors.greenAccent),
    BottomNavigationBarItem(icon: Icon(Icons.search, size: common_padding_l, color: Colors.black), label: '', backgroundColor: Colors.blue),
    BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: common_padding_l, color: Colors.yellow), label: '', backgroundColor: Colors.purple),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined, size: common_padding_l, color: Colors.blue), label: '', backgroundColor: Colors.white),
    BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: common_padding_l, color: Colors.purple), label: '', backgroundColor: Colors.grey),
  ];

  int _selectedIndex = 0;

  static List<Widget> _screens = <Widget>[
    FeedScreen(),
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items:btmNavItems,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
          currentIndex: _selectedIndex,
          onTap: _onBtmItemClick,
      ),
    );
  }

  void _onBtmItemClick(int index) {
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}