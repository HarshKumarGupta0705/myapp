import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/screen/conversation.dart';
import 'package:myapp/session/session_management.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<User> _userList = []; //empty list of user type
  String _currUserId; //to hold the id of current user
  //to access the firestore for the collectio -"user"
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    SessionManagement.getLoginUID().then((value) {
      setState(() {
        _currUserId = value;
      });
    });
    createContactList(); //invoke methoda to get the list
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int i) {
        User _user = _userList[i];
        return Wrap(
          children: [
            ListTile(
              leading: _user.imageUrl == ''
                  ? Icon(Icons.person)
                  : CircleAvatar(
                      backgroundImage: NetworkImage(_user.imageUrl),
                    ),
              title: Text(_user.name),
              subtitle: Text(_user.UserDesc),
              onTap: () {
                print('${_user.UserEmail}');
                // Navigator.pushReplacementNamed(context, Conversation.ROUTE_CONVERSION,
                // arguments: _user  );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => Conversation(user: _user),
                  ),
                );
              },
            ),
            Divider(
              height: 5,
              color: Colors.black,
            ),
          ],
        );
      },
      itemCount: _userList.length,
    );
  }

  void createContactList() async {
    //code that will fetch the users present in the database

    ref.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs
          .where((element) => element.id != _currUserId)
          .where((doc) =>
              doc.id !=
              _currUserId) //if  the login user id doesnt match then need to retrive the values
          .forEach((DocumentSnapshot doc) {
        //property named used within [] is acccording to the one of firestore
        User user = User(
          name: doc['name'],
          desc: doc['desc'],
          email: doc['email'],
          imageUrl: doc['image'],
        );
        _userList.add(user); //additing the data in existing list
      });
      // print('total size : ${_userList.Length}');
    }).catchError((onError) => print(onError));
  }
}
