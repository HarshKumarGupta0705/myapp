import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screen/login.dart';
import 'package:myapp/screen/after_login.dart';
import 'package:myapp/session/session_management.dart';
import 'package:myapp/storage/local_data.dart';

import 'login.dart';

class SplashScreen extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      
      future: _initialization,
      builder: (BuildContext cxt, AsyncSnapshot snapshot) {
        return Scaffold(
          backgroundColor: Colors.green[700],
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  "Lets' Chit Chat",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Lobster',
                  ),
                ),
                // ImageZone(),
                 
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(70),
                  child: ElevatedButton(
                    onPressed: () {
                      ///write the code to take action against the click
                      ///on the based of the connection with the server
                      ///trying to initiate rounting
                      if (snapshot.connectionState == ConnectionState.done) {
                        //routing code
                        performRouting(context);
                      } else {
                        print('error');
                      }
                      //function
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Lobster',
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.blue;
                          return Colors.blueAccent;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void performRouting(BuildContext context) {
    SessionManagement.getLoginStatus().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, AfterLoginScreen.AFTERLOGIN);
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_LOGIN);
      }
    }).catchError((onError) => print(onError));
  }
}
// class ImageZone extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//       itemBuilder: (ctx, index) => Column(
//         children: [
//           Image.asset(LocalData.pagerList[index]['image']),
//           Text(LocalData.pagerList[index]['title'])
//         ],
//       ),
//       itemCount: LocalData.pagerList.length,
//     );
//   }
// }


