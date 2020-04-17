import 'package:emergency/models/user.dart';
import 'package:emergency/providers/api.dart';
import 'package:flutter/material.dart';


class UserProvider with ChangeNotifier{
  Api _api = new Api();
  String _auth;
  User _user;

  UserProvider(this._auth);
  
 Future<User> getUserAuth() async {
 
    var doc = await _api.getDocumentById(_auth);
    
    
    _user= User.fromMap(doc.data, doc.documentID) ;
     
     notifyListeners();
     return _user;
  }
  User get user{
    this.getUserAuth();
    return _user;
  }



  Future updateProduct(User data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    _user=data;
    notifyListeners();
    

  }

  Future addUser(User data) async{
    data.id=_auth;
    await _api.ref.document(data.id).setData(data.toJson());
    
    notifyListeners();

    return ;

  }
  Future updateUser(User data) async{
     data.id=_auth;
    _api.ref.document(data.id).updateData(data.toJson());
     
    notifyListeners();

    return ;
  }
 


}