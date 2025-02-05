import 'package:asb_app/src/views/dashboard/home/index.dart';
import 'package:asb_app/src/views/dashboard/profiles/index.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const TimeDistribusi(),
    const AccountSettings()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png', width: 40),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/person.png', width: 50),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        elevation: 0,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,        
        selectedItemColor: Colors.black,
        unselectedIconTheme: const IconThemeData(color: Colors.black26),
        selectedIconTheme: const IconThemeData(size: 25),
        unselectedItemColor: Colors.black38,
        onTap: _onItemTapped,
      ),
    );
  }
}