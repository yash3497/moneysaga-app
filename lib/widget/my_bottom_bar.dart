import 'package:flutter/material.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/home/cmd_message_screen.dart';
import 'package:magnus_app/views/home/home_screen.dart';
import 'package:magnus_app/views/my_learning_tab/my_learning_screen.dart';
import 'package:magnus_app/views/profile_tab/profile_screen.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({Key? key}) : super(key: key);

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    CmdMessageScreen(),
    MyLearning(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/learning.png')),
            label: 'My Learning',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/Profile.png')),
            label: 'My Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: yellow,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
