import 'package:emergency/models/message.dart';
import 'package:emergency/pages/history.dart';
import 'package:emergency/providers/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';

class HistoryListScreen extends StatefulWidget {
  @override
  _HistoryListScreenState createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: StreamBuilder(
        stream:
            Provider.of<MessageProvider>(context, listen: false).fetchAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.documents.length == 0) {
            return Center(
              child: const Text('Got no history yet'),
            );
          }
          _messages = snapshot.data.documents
              .map<Message>((doc) => Message.fromMap(doc.data, doc.documentID))
              .toList();
          return ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, i) => Card(
                  color: Color(0xFF111328),
                  child: ListTile(
                    title: Text(
                        formatTime(_messages[i].time.millisecondsSinceEpoch)),
                        trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).pushNamed(History.routeName,
                          arguments: _messages[0].id);
                    },
                  )));
        },
      ),
    );
  }
}
