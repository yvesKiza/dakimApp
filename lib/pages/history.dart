import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/models/message.dart';
import 'package:emergency/pages/map.dart';
import 'package:emergency/providers/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';

class History extends StatefulWidget {
  static const routeName = '/history';
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Message _message;
  String id;
  @override
  Future<void> didChangeDependencies() async {
    id = ModalRoute.of(context).settings.arguments as String;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("emergency"),
        ),
        body: StreamBuilder(
            stream: Provider.of<MessageProvider>(context, listen: false)
                .messageStream(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: const Text('sorry error occured'),
                );
              }
              DocumentSnapshot doc = snapshot.data;

              try {
                _message = Message.fromMap(doc.data, doc.documentID);
              } catch (error) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 60),
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Time"),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    DateFormat('dd MMM yyyy hh:mm').format(
                                        new DateTime.fromMicrosecondsSinceEpoch(
                                            _message
                                                .time.microsecondsSinceEpoch)),
                                    style: new TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    formatTime(
                                        _message.time.millisecondsSinceEpoch),
                                    style: new TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 60, left: 20, right: 20),
                                  child: Card(
                                    color: Colors.white,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    elevation: 18.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text("Message",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF111328))),
                                            ),
                                            Divider(color: Color(0xFF111328)),
                                            Text(_message.text,
                                                style: TextStyle(
                                                    color: Color(0xFF111328))),
                                          ],
                                        )),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 60, left: 20, right: 20),
                                  child: Card(
                                    color: Colors.white,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    elevation: 18.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text("Contacts",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF111328))),
                                            ),
                                            Divider(color: Color(0xFF111328)),
                                            for (var item in _message.receivers)
                                              Card(
                                                color: Colors.white70,
                                                child: ListTile(
                                                    title: Text(item.names,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF111328))),
                                                    subtitle: Text(
                                                        item.phoneNumber,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF111328)))),
                                              ),
                                          ],
                                        )),
                                  ),
                                ),
                                _message.latitude != null
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            top: 30,
                                            left: 20,
                                            right: 20,
                                            bottom: 30),
                                        child: RaisedButton.icon(
                                          onPressed: () async {
                                            // MapView(_message.latitude, _message.longitude);
                                            await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                fullscreenDialog: true,
                                                builder: (ctx) => MapView(
                                                    _message.latitude,
                                                    _message.longitude),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.map),
                                          textColor: Colors.white,

                                          label: Text("View on Map"),
                                           color: Color(0xFF111328),
                                        ))
                                    : ""
                              ],
                            )

                            // subtitle: Text(  DateFormat('dd MMM yyyy hh:mm').format(new DateTime.fromMicrosecondsSinceEpoch(_message.time.microsecondsSinceEpoch)),),

                            ),
                      ),
                    ])))
                  ]);
            }));
  }
}
