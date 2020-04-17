import 'package:emergency/pages/add_contact.dart';
import 'package:emergency/pages/add_user.dart';
import 'package:emergency/pages/edit_contacts.dart';
import 'package:emergency/pages/edit_user.dart';
import 'package:emergency/pages/tabs_screen.dart';
import 'package:emergency/providers/contactProvider.dart';
import 'package:emergency/providers/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/UserProvider.dart';
import './pages/auth_add.dart';
import './services/auth.dart';
import './pages/splash_screen.dart';
import './pages/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider.value(
          value: AuthService() ,
        ),
     
     ChangeNotifierProxyProvider<AuthService, ContactProvider>(
          builder: (ctx, auth, previous) => ContactProvider(
                
                auth.userId,
                previous == null ? [] : previous.contacts,
              ),
        ),
        ChangeNotifierProxyProvider<AuthService, UserProvider>(
          builder: (ctx, auth, previous) => UserProvider(
                
                auth.userId,
                
              ),
        ),
        ChangeNotifierProxyProvider<AuthService,MessageProvider>(
          builder: (ctx, auth, previous) => MessageProvider(
                
                auth.userId,
                
              ),
        ),
        
        
       
    ],
    child: Consumer<AuthService>(
        builder: (ctx, auth, _) => MaterialApp(
              title: 'Woman',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? BottomNavBar()
                  : FutureBuilder(
                     
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                  EditContactScreen.routeName: (ctx) => EditContactScreen(),
                  EditUserScreen.routeName: (ctx)=> EditUserScreen(),
                  AddContactScreen.routeName: (ctx)=>AddContactScreen(),
                  AddUserScreen.routeName: (ctx)=>AddUserScreen(),
                  AuthAddScreen.routeName: (ctx)=>AuthAddScreen(),
                  

              },
            ),
      ),
    );
  }
} 
  

