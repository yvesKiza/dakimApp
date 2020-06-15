
import 'package:emergency/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MessageItem extends StatefulWidget {
  final Message _message;

  MessageItem(this._message);

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  
  

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
          
            title: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(new DateTime.fromMicrosecondsSinceEpoch(widget._message.time.microsecondsSinceEpoch)),
            ),
           
          ),
         
         
        ],
      ),
    );
  }
}
