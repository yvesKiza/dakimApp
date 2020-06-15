
import 'package:emergency/pages/edit_contacts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contactProvider.dart';
import '../widgets/contactWidget.dart';
class Contacts extends StatelessWidget {
  
 
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ContactProvider>(context, listen: false)
        .fetchAuth();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text('Contacts',textAlign: TextAlign.center)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditContactScreen.routeName);
            },
          ),
        ],
      ),
       body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ContactProvider>(
                      builder: (ctx,data, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                      itemCount: data.contacts.length,
                      itemBuilder: (ctx, i) =>  Column(
                                    children: [
                                      UserContactItem(data.contacts[i].id,
                                      data.contacts[i].names,
                                      data.contacts[i].phoneNumber,
                                      data.contacts[i].relationship),
                                   
                                        ],
                                  ),
                            ),
                          ),
                    ),
                  ),
      ),
    );
  }
}
