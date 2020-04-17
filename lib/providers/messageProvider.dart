
import 'package:emergency/models/message.dart';
import 'package:flutter/cupertino.dart';
import '../providers/api.dart';

class MessageProvider with ChangeNotifier{
   Api _api = new Api();
   
   List<Message> messages=[];
 

 

  String _auth;
  MessageProvider(this._auth);
  Future<void> fetchAuth() async {
    var result = await _api.ref.document(_auth).collection('messages').getDocuments();
    List<Message> conts=[];
    conts = result.documents
        .map((doc) => Message.fromMap(doc.data, doc.documentID))
        .toList();

        messages=conts.reversed.toList();

   

  }
   Future<void> addMessage(Message data) async{
    
       data.id=_api.ref.document(_auth).collection('messages').document().documentID;
   
    await _api.ref.document(_auth).collection('messages').document(data.id).setData(data.toJson()) ;
    
    
    messages.add(data);
     notifyListeners();
    



  }




}