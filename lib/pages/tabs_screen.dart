import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:emergency/pages/history_list.dart';
import '../helper/listenShake.dart';
import '../pages/contacts.dart';
import '../pages/settings.dart';
import 'package:emergency/pages/pageProducts.dart';
import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  
 
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
     ListenShake.start();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
   
    child: Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            PageProducts(),
            Contacts(),
            HistoryListScreen(),
            Settings()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: Color(0xFFEB1555),
        
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
             activeColor: Colors.white,
            inactiveColor: Colors.white,

          ),
          BottomNavyBarItem(
            title: Text('Contacts'),
            icon: Icon(Icons.perm_contact_calendar),
             activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            title: Text('Records'),
            icon: Icon(Icons.filter_frames),
             activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            title: Text('Settings'),
            icon: Icon(Icons.settings),
             activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
        ],
      ),
    ));
  }
}