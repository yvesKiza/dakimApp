import 'package:emergency/providers/UserProvider.dart';
import 'package:emergency/providers/contactProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/contact.dart';




class AuthService with ChangeNotifier {
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance ;

  FirebaseUser _user;
 
   

   bool get isAuth{
     return _user!=null;
   }
   String get userId{
     if(_user!=null){
       return _user.uid;
     }
     else null;
   }


  Future loginWithEmail({@required String email,@required String password}) async {
    try {
     
     var res= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    
      _user=res.user;
      notifyListeners();
    } catch (e) {
     String errorMessage;
    switch (e.code) {
     case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "something happened,check your internet";
    }
    throw(errorMessage);
  
    
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required User user,
    @required List<Contact> contact,
  }) async {
   
    try {
     
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    
      _user=authResult.user;
     await  UserProvider(_user.uid).addUser(user);
     await   ContactProvider(_user.uid,contact).addContactList();
        notifyListeners();
    } catch (e) {
       String errorMessage;
      switch (e.code) {
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Anonymous accounts are not enabled";
        break;
      case "ERROR_WEAK_PASSWORD":
        errorMessage = "Your password is too weak";
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email is invalid";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorMessage = "Email is already in use on different account";
        break;
      case "ERROR_INVALID_CREDENTIAL":
        errorMessage = "Your email is invalid";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }
        throw(errorMessage);
    }
  }
 
  Future signOut() async {
    _firebaseAuth.signOut();
   _user=null;
    
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
  
  
}