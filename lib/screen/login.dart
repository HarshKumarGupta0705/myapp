import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screen/after_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/session/session_management.dart';

import 'package:myapp/screen/signup.dart';

class LoginScreen extends StatefulWidget {
  static const ROUTE_LOGIN = '/route-login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: SafeArea(
        child: Form(
          key: _fKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                IconButton(
                    color: Colors.blue,
                    iconSize: 50,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    }),
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontFamily: 'Lobster',
                    fontSize: 40,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: Image.asset(
                        "assets/images/login1.jpg",
                      ),
                    )),
                SizedBox(height: 50),
                emailInput(),
                passInput(),
                loginBtn(context),
                anotherWidgget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email: ',
          hintText: "abc@gmail.com",
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 4, style: BorderStyle.solid),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String input) {
          if (input.isEmpty) return 'Please enter your email';
          return null;
        },
        controller: _emailCtrl,
      ),
    );
  }

  Widget passInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Password: ',
          hintText: "xxxxxxxxx",
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 4, style: BorderStyle.solid),
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        validator: (String input) {
          if (input.isEmpty)
            return 'Please enter your Password';
          else if (input.length < 5)
            return 'Password must be atleast 5 characters';
          return null;
        },
        controller: _passCtrl,
      ),
    );
  }

  Widget loginBtn(context) {
    return ElevatedButton(
      onPressed: () {
        performLogin(context);
        print('Go To Login Screen');
      },
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue;
            return Colors.blueAccent;
          },
        ),
      ),
    );
  }

  void performLogin(context) async {
    //code to validate the form
    if (_fKey.currentState.validate()) {
      print('hi');
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailCtrl.text, password: _passCtrl.text);
        print('hey harsh');
        User user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            notifyUser(context, 'Login Successfully');
            SessionManagement.storeLogin(uid: user.uid);
            Navigator.pushReplacementNamed(
                context, AfterLoginScreen.AFTERLOGIN);
          } else {
            notifyUser(context, 'Need to verify the email');
          }
        } else {
          notifyUser(context, "User not registered");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          notifyUser(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          notifyUser(context, 'The account already exists for that email.');
        }
      } catch (e) {
        notifyUser(context, e);
      }
    }
  }

  void notifyUser(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
      ),
    );
  }

  Widget anotherWidgget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Want to register now?'),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, SignupScreen.R);
            //function
          },
          child: Text(
            'SignUp',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontFamily: 'Lobster',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
