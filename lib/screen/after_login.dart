import 'package:flutter/material.dart';
import 'package:myapp/screen/login.dart';
import 'package:myapp/session/session_management.dart';
import 'package:myapp/storage/local_data.dart';

class AfterLoginScreen extends StatefulWidget {
  static const AFTERLOGIN = '/route-afterlogin';
  @override
  _AfterLoginScreenState createState() => _AfterLoginScreenState();
}

class _AfterLoginScreenState extends State<AfterLoginScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: Text(LocalData.bottomNavList[_selectedIndex]['title']),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              showAlertDialog(context);
            },
            itemBuilder: (con) => [
              PopupMenuItem<String>(
                  value: 'item',
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 20,
                    children: [Icon(Icons.remove_circle), Text('Logout')],
                  )),
            ],
          ),
        ],
        // backgroundColor: Colors.white,
      ),
      body: LocalData.bottomNavList[_selectedIndex]['screen'],
      bottomNavigationBar: createBottomNav(),
    );
  }

  Widget createBottomNav() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: LocalData.bottomNavList[0]['title'],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: LocalData.bottomNavList[1]['title'],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: LocalData.bottomNavList[2]['title'],
        ),
      ],
      backgroundColor: Colors.cyanAccent[700],
      selectedItemColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: (int cIndex) {
        setState(() {
          _selectedIndex = cIndex;
        });
      },
    );
  }

  void showAlertDialog(BuildContext cxt) {
    showDialog(
      context: cxt,
      barrierDismissible: false,
      builder: (BuildContext con) => AlertDialog(
        title: Text('Logout Dialog'),
        content: Text('Do you really want to sign out?'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ), //dismissing Dialog
            onPressed: () {
              Navigator.pop(cxt);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.blue,
            ),
            onPressed: () {
              SessionManagement.removeUser().then(
                (value) => Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.ROUTE_LOGIN, (route) => false),
              );
            },
          ),
        ],
      ),
    );
  }
}
