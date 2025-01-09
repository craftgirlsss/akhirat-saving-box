// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';

// class Mainpage extends StatefulWidget {
//   const Mainpage({super.key});

//   @override
//   State<Mainpage> createState() => _MainpageState();
// }

// class _MainpageState extends State<Mainpage> {

//   int _selectedIndex = 0;
//   static final List<Widget> _widgetOptions = <Widget>[
//     const Home(),
//     const SearchTab(),
//     const Text("Home"),
//     const Text("Home"),
//     const Text("Home"),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBody: true,
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Iconsax.home_1_bold),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Iconsax.search_normal_1_outline),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add, size: 30),
//             label: 'Add',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Clarity.chat_bubble_solid),
//             label: 'Chat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.person_alt_circle_fill),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         elevation: 0,
//         showSelectedLabels: false,
//         type: BottomNavigationBarType.shifting,
//         backgroundColor: Colors.white,        
//         selectedItemColor: Colors.black,
//         unselectedIconTheme: const IconThemeData(color: Colors.black26),
//         selectedIconTheme: const IconThemeData(size: 25),
//         unselectedItemColor: Colors.black38,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }