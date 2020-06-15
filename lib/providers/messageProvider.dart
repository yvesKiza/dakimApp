
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/models/message.dart';
import 'package:flutter/cupertino.dart';
import '../providers/api.dart';

class MessageProvider with ChangeNotifier{
   Api _api = new Api();
   
   List<Message> messages=[];
 

 

  String _auth;
  MessageProvider(this._auth);
  Stream fetchAuth() {
    var result =  _api.ref.document(_auth).collection('messages').orderBy("time",descending: true).snapshots();
    return result;
    

   

  }
   Stream<DocumentSnapshot> messageStream(String id) {
    return  _api.ref.document(_auth).collection('messages').reference().document(id).snapshots();
  }
  Future<Message> getMessage(String id) async{
    var _message= await _api.ref.document(_auth).collection('messages').document(id).get();
     return Message.fromMap(_message.data, id);
  }

  
   Future<void> addMessage(Message data) async{
    
       data.id=_api.ref.document(_auth).collection('messages').document().documentID;
   
    await _api.ref.document(_auth).collection('messages').document(data.id).setData(data.toJson()) ;
    
    
    messages.add(data);
     notifyListeners();
    



  }




}