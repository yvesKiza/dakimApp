import 'package:emergency/models/contact.dart';

class User{
  String id;
  String names;
  
  String phoneNumber;
  
  User({this.id,this.names,this.phoneNumber});
  User.fromMap(Map snapshot,String id ):
   id=id ?? '',
   names=snapshot['names'] ?? '',
   
   phoneNumber=snapshot['phoneNumber']??'';

   toJson(){
     return {
       
       "names":names,
       
       "phoneNumber":phoneNumber,
     };
   }


}