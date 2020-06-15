import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/models/contact.dart';


class Message{
  String id;
  List<Contact> receivers;
  double longitude;
  double latitude;
  String text;
  Timestamp time=Timestamp.fromDate(DateTime.now());
  
  
 Message();
   Message.fromMap(Map snapshot,String id ):
   id=id ?? '',
   longitude=snapshot['longitude']??'',
  latitude=snapshot['latitude']??'',
   text=snapshot['text']??'',
     time=snapshot['time']??'', 
   receivers= ( snapshot['receiver'] ?? '' )
              .map<Contact>(
                (item){
                   return Contact.fromMap(item,item['id']);
                } ,
              )
              .toList()  ;

   toJson(){
     return {
       "id":id,
     
       "latitude":latitude,
        "longitude":longitude,
       "text":text,
       "receiver":receivers.map((f){
         return f.toJson();
       }).toList(),
       "time":time,
     };
   }




}