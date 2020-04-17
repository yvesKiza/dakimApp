import 'package:emergency/models/contact.dart';


class Message{
  String id;
  List<Contact> receivers;
  String latitude;
  String longitude;
  String text;
  DateTime time=new DateTime.now();
  
  Message({this.id,this.latitude,this.longitude,this.text,this.receivers,this.time});

   Message.fromMap(Map snapshot,String id ):
   id=id ?? '',
   latitude=snapshot['latitude']??'',
   longitude=snapshot['longitude']??'',
   text=snapshot['text']??'',
   receivers= ( snapshot['receivers'] ?? '' as List<dynamic>)
              .map(
                (item) => Contact(
                      id: item['id'],
                      names: item['names'],
                      userID: item['userID'],
                      phoneNumber: item['phoneNumber'],
                      relationship: item['relationship'],
                    ),
              )
              .toList();

   toJson(){
     return {
       "id":id,
       "latitude":latitude,
       "longitude":longitude,
       "text":text,
       "receiver":receivers,
     };
   }




}