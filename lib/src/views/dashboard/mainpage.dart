import 'package:asb_app/src/views/dashboard/home/work_step_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:asb_app/src/views/dashboard/profiles/index.dart';
import '../../components/global/index.dart';
import '../../components/textsyle/index.dart';
// import 'home/index.dart';
import 'home/timeline.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    PackageDeliveryTrackingPage(),
    const TimeLine(),
    const AccountSettings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          systemNavigationBarColor: GlobalVariable.secondaryColor
      ),
      child: Scaffold(
        extendBody: true,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Clarity.timeline_line),
              label: 'Work Load',
            ),
            BottomNavigationBarItem(
              icon: Icon(Clarity.expand_card_line),
              label: 'Time Line',
            ),
            BottomNavigationBarItem(
              icon: Icon(Bootstrap.menu_button_fill, size: 21),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: GlobalVariable.secondaryColor,
          selectedLabelStyle: textStyle.defaultTextStyleMedium(fontSize: 14),
          unselectedLabelStyle: textStyle.defaultTextStyleMedium(),
          selectedItemColor: Colors.white,
          selectedIconTheme: const IconThemeData(size: 25),
          unselectedItemColor: Colors.white.withOpacity(0.6),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}