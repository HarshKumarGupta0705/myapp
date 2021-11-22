import 'package:flutter/material.dart';
import 'package:myapp/model/user.dart';

class Conversation extends StatefulWidget {
  static const ROUTE_CONVERSION = '/route-conversation';
  User user;
  Conversation({this.user});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Wrap(
        children: [
          Expanded(
            child: widget.user.imageUrl == ''
                ? Icon(Icons.person)
                : CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.imageUrl),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,),
            child: Text(widget.user.UserName),
          )
        ],
      ),
      ),
      body: Container(),
    );
  }
}
