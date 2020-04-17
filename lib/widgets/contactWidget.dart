import 'package:emergency/pages/edit_contacts.dart';
import 'package:flutter/material.dart';



class UserContactItem extends StatelessWidget {
  final String id;
  final String names;
  final String phone;

  UserContactItem(this.id, this.names, this.phone);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(names),
      leading: CircleAvatar(
        child: new Text(names[0]),
      ),
       subtitle: Text(phone),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditContactScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
          
          ],
        ),
      ),
    );
  }
}
