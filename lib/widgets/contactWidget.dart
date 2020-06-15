import 'package:emergency/pages/edit_contacts.dart';
import 'package:flutter/material.dart';



class UserContactItem extends StatelessWidget {
  final String id;
  final String names;
  final String phone;
  final String relationship;

  UserContactItem(this.id, this.names, this.phone,this.relationship);

  @override
  Widget build(BuildContext context) {
    return Card(
      color:  Color(0xFF111328),
      child: ListTile(
        title: Text(names),
        leading: CircleAvatar(
          child: new Text(names[0]),
          backgroundColor: Colors.white,
        ),
         subtitle: Text(phone),
         onTap:  () {
                  Navigator.of(context)
                      .pushNamed(EditContactScreen.routeName, arguments: id);
                },
          
        trailing: Text(relationship),
      ),
    );
  }
}
