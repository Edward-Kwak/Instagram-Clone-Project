import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home, size: 24.0, color: Colors.orange), label: 'Home', backgroundColor: Colors.greenAccent),
    BottomNavigationBarItem(icon: Icon(Icons.search, size: 24.0, color: Colors.black), label: 'Search', backgroundColor: Colors.blue),
    BottomNavigationBarItem(icon: Icon(Icons.backpack, size: 24.0, color: Colors.yellow), label: 'Inventory', backgroundColor: Colors.purple),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 24.0, color: Colors.blue), label: 'My', backgroundColor: Colors.white),
    BottomNavigationBarItem(icon: Icon(Icons.settings, size: 24.0, color: Colors.purple), label: 'Settings', backgroundColor: Colors.grey),
  ];

  int _selectedIndex = 0;

  static List<Widget> _screens = <Widget>[
    Container(color: Colors.white),
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
    Container(color: Colors.amber),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code_Split & Nav Bar'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items:btmNavItems,
          showSelectedLabels: true,
          showUnselectedLabels: true,
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