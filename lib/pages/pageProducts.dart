import 'package:emergency/widgets/icon_content.dart';
import 'package:flutter/material.dart';

class PageProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency'),
      ),
      body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(children: <Widget>[
     GestureDetector(
      onTap: () async {
        //  await Provider.of<EmergencyProvider>(context, listen: false)
        // .sendNotification();
        // bool canVibrate = await Vibrate.canVibrate;
        // if(canVibrate){
        //   Vibrate.vibrate();
        // }
        //  Future<bool> canVibrate =  Vibrate.canVibrate;
        //    canVibrate.then((value) {
        //      if(value){
        //          Vibrate.vibrate();
        //      }
        //    });
      },
      child:Container(
      height: MediaQuery.of(context).size.height/4,
      width:MediaQuery.of(context).size.width/4 ,
      
     child: IconContent(
                    icon: Icons.power_settings_new,
                    label: 'Activate',
                  ),
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Color(0xFF111328),
          borderRadius: BorderRadius.circular(10.0),
        ),
      
      
    ))

    ,
    
    ])))]));
  }
}