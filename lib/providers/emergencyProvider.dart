import 'package:emergency/models/contact.dart';
import 'package:emergency/models/message.dart';
import 'package:emergency/models/user.dart';
import 'package:call_number/call_number.dart' show CallNumber;
import 'package:emergency/providers/UserProvider.dart';
import 'package:emergency/providers/contactProvider.dart';
import 'package:emergency/providers/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms/sms.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class EmergencyProvider with ChangeNotifier{
 String _auth;
 
 TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: 'AC5b360954362486b7ead8763b748c6ed4',
        authToken: '8bad25e7986b5602f22daada3dc4398d',
        twilioNumber: '+12513599640');

  EmergencyProvider(this._auth);

  Future sendNotification() async {
    Message _message=new Message();
    User _user= await  UserProvider(_auth).getUserAuth();
   List<Contact> contacts=await  ContactProvider(this._auth,null).getContacts();
   print("DSASDsadasdsadas  "+contacts.length.toString());
  _message.receivers=contacts;
   Position _position;

  
    _position= await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _message.longitude=_position.longitude;
    _message.latitude=_position.latitude;
    if(_position!=null)
    _message.text="help please. i am ${_user.names} this is an emergency. My location is http://maps.google.com/?q=${_position.latitude},${_position.longitude} this google map url";
   else
    _message.text="help please. i am ${_user.names} this is an emergency";
  // bool hasInternet=await CheckInternetConnection().check;


 
  await  sendMessageUsingSMS(_message);
   
   
  //   await new CallNumber().callNumber('${contacts[1].phoneNumber}');



  }
  Future<void> sendMessageUsingHttp(Message message,List<Contact> contacts) async {
    
    for(int i=0;i<contacts.length;i++) {
     
  twilioFlutter.sendSMS(
        toNumber: contacts[i].phoneNumber, messageBody:message.text);
  
  
  }
   await MessageProvider(_auth).addMessage(message);
  }

  Future<void> sendMessageUsingSMS(Message message) async{
      for (var item in message.receivers) {
    SmsSender sender = new SmsSender();
  String address =item.phoneNumber;
  
  sender.sendSms(new SmsMessage(address, message.text));
  

      }
       await MessageProvider(_auth).addMessage(message);
  }
      
    

  

}