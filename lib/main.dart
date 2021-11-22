import 'package:flutter/material.dart';
import 'package:myapp/screen/after_login.dart';
import 'package:myapp/screen/login.dart';
import 'package:myapp/screen/signup.dart';
import 'package:myapp/screen/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
}

//Root widget for the project

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget root',
      

      // home: SplashScreen(),  
      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(),
        LoginScreen.ROUTE_LOGIN: (context) => LoginScreen(),
        SignupScreen.R: (context) => SignupScreen(),
        AfterLoginScreen.AFTERLOGIN: (context) => AfterLoginScreen(), 
         
        
      },
    );
  }
}
