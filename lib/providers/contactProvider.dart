import 'package:emergency/models/contact.dart';
import 'package:emergency/providers/api.dart';
import 'package:flutter/material.dart';


class ContactProvider with ChangeNotifier{
  Api _api = new Api();
 

  List<Contact> _contacts=[];
 List<Contact> get contacts{
   return _contacts;
 }

  String _auth;

  ContactProvider(this._auth, this._contacts);
 
  
  Contact getContactById(String id)  {
     return _contacts.firstWhere((prod) => prod.id == id) ;
  }


 Future<void> fetchAuth() async {
    var result = await _api.ref.document(_auth).collection('contacts').getDocuments();
    List<Contact> conts=[];
    conts = result.documents
        .map((doc) => Contact.fromMap(doc.data, doc.documentID))
        .toList();

        _contacts=conts;

   
  }
 Future<bool>  exists(Contact contact) async{
     var res = await _api.ref.document(_auth).collection('contacts').where("phoneNumber",isEqualTo: contact.phoneNumber).getDocuments();
      if (res.documents.length==0 ){
    return false;
   }
   else {
      List<Contact> _cats= res.documents.map<Contact>((doc) => Contact.fromMap(doc.data, doc.documentID)).toList();
      final index=_cats.indexWhere((d)=>d.id==contact.id);
      if(index>=0){
        return false;
      }
      else{
        return true;
      }
  }
 }
  Future<List<Contact>> getContacts() async{
    var result = await _api.ref.document(_auth).collection('contacts').getDocuments();
    List<Contact> conts=[];
    conts = result.documents
        .map((doc) => Contact.fromMap(doc.data, doc.documentID))
        .toList();

       
        return conts;
  }
  Future updateContact(Contact data,String id) async{
      final prodIndex = _contacts.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        if(await this.exists(data)){
     throw new Exception("Contact exists");
   }else{
    await _api.ref.document(_auth).collection('contacts').document(id).updateData(data.toJson()) ;
     _contacts[prodIndex]=data;
    print("updating");
    notifyListeners();
      }}
    return ;
  
  }

  Future<void> addContact(Contact data) async{
    data.userID=_auth;
    data.id=_api.ref.document(_auth).collection('contacts').document().documentID;
   
    await _api.ref.document(_auth).collection('contacts').document(data.id).setData(data.toJson()) ;
    _contacts.add(data);
     notifyListeners();
    



  }
  Future<void> addContactList() {
    _contacts.forEach((f){
        this.addContact(f);
    });
    
  }



}