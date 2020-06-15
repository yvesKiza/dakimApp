import 'package:emergency/pages/add_contact.dart';
import 'package:emergency/pages/add_user.dart';
import 'package:emergency/pages/edit_contacts.dart';
import 'package:emergency/pages/edit_user.dart';
import 'package:emergency/pages/history.dart';
import 'package:emergency/pages/tabs_screen.dart';
import 'package:emergency/providers/contactProvider.dart';
import 'package:emergency/providers/emergencyProvider.dart';
import 'package:emergency/providers/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/UserProvider.dart';
import './pages/auth_add.dart';
import './services/auth.dart';
import './pages/splash_screen.dart';
import './pages/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthService(),
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
        ChangeNotifierProxyProvider<AuthService, MessageProvider>(
          builder: (ctx, auth, previous) => MessageProvider(
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<AuthService, EmergencyProvider>(
          builder: (ctx, auth, previous) => EmergencyProvider(
            auth.userId,
          ),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Woman',
          theme: ThemeData.dark().copyWith(
            primaryColor: Color(0xFF0A0E21),
            scaffoldBackgroundColor: Color(0xFF0A0E21),
          ),
          home: auth.isAuth
              ? BottomNavBar()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            EditContactScreen.routeName: (ctx) => EditContactScreen(),
            EditUserScreen.routeName: (ctx) => EditUserScreen(),
            AddContactScreen.routeName: (ctx) => AddContactScreen(),
            AddUserScreen.routeName: (ctx) => AddUserScreen(),
            AuthAddScreen.routeName: (ctx) => AuthAddScreen(),
            History.routeName: (ctx) => History(),
          },
        ),
      ),
    );
  }
}
