import 'package:emergency/pages/edit_user.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../providers/UserProvider.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth.dart';

 User _usr;
 
class Settings extends StatefulWidget {

  
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  

  @override
  void initState() {
  super.initState();
  print("yes");
   
     
     Provider.of<UserProvider>(context, listen: false).getUserAuth().then((val){
    setState(() {
      _usr=val;
    
    });
    
     
     
   });
   
   
  
  }
@override

  Widget build(BuildContext context) {
     
      return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text('Settings',textAlign: TextAlign.center)),
      ),
      body:      SettingsList(
        sections: [
          SettingsSection(
            title: 'Account',
            
            tiles: [
              SettingsTile(
                title: _usr!=null?_usr.names:'null',
               
                leading: Icon(Icons.supervised_user_circle),
                onTap: () {
                  Navigator.of(context)
                    .pushNamed(EditUserScreen.routeName, arguments: _usr);
                },
              ),
              SettingsTile(
                title: 'Email',
               
                leading: Icon(Icons.email),
                onTap: () {},
              ),
              SettingsTile(
                title: 'Password',
               
                leading: Icon(Icons.lock),
                onTap: () {},
              ),
              
            ],
          ),
             SettingsSection(
              title: 'General',
            tiles: [
              SettingsTile.switchTile(
                title: 'Listen to vibration',
                leading: Icon(Icons.vibration),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile(
                title: 'About us',
               
                leading: Icon(Icons.question_answer),
                onTap: () {},
              ),
             SettingsTile(
                title: 'Log out',
               
                leading: Icon(Icons.exit_to_app),
                onTap: () async {
                   await Provider.of<AuthService>(context, listen: false).signOut();
          
                },
              ),
              
            ],
          ),
        ],
      )
      );
  }
}