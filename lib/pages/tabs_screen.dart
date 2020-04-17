import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:emergency/pages/messages.dart';
import '../pages/contacts.dart';
import '../pages/settings.dart';
import 'package:emergency/pages/pageProducts.dart';
import 'package:flutter/material.dart';
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  
  
  GlobalKey _bottomNavigationKey = GlobalKey();
  final PageProducts _listProducts=PageProducts();
  final Contacts _contacts=Contacts();
   final Messages _messages=Messages();
  final Settings _settings= Settings();

  Widget _showPage=new PageProducts();
   
   Widget _pageChooser(int page){
     switch (page) {
       case 0:
       return _listProducts;
       break;
       case 1:
       return _contacts;
       break;
       case 2:
       return _messages;
       break;
      
       case 3:
       return _settings;
       break;
       
       
       
       default:
       return new Container(
         child: new Center(child: new Text('No page found',
         style:new TextStyle(fontSize: 30)),),); 
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.perm_identity, size: 30),
            Icon(Icons.receipt, size: 30),
            Icon(Icons.settings, size: 30),
           
          ],
          color: Colors.purple,
          
          buttonBackgroundColor:  Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int index) {
            setState(() {
              _showPage=_pageChooser(index);
            });
          },
        ),
        body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}