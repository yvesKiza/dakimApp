import 'package:emergency/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/messageProvider.dart';
class Messages extends StatelessWidget {
  
 
  Future<void> _refreshMessages(BuildContext context) async {
    Provider.of<MessageProvider>(context, listen: false)
        .fetchAuth();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text('Emergency records',textAlign: TextAlign.center)),
        
      ),
       body: FutureBuilder(
        future: _refreshMessages(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshMessages(context),
                    child: Consumer<MessageProvider>(
                       builder: (ctx, data, child) => ListView.builder(
                      itemCount: data.messages.length,
                      itemBuilder: (ctx, i) => MessageItem(data.messages[i]),
                    ),
                    ),
                  ),
      ),
    );
  }
}
