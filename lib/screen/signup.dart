import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignupScreen extends StatefulWidget {
  static const R = '/route-signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final _fKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();

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
                  'Sign Up',
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
                        "assets/images/signup.jpg",
                      ),
                    )),
                SizedBox(height: 50),
                nameInput(),
                emailInput(),
                passInput(),
                passInput1(),
                signupbtn(context),
                anotherWidgget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Name: ',
          hintText: "abc...",
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 4, style: BorderStyle.solid),
          ),
        ),
        keyboardType: TextInputType.name,
        validator: (String input) {
          if (input.isEmpty) return 'Please enter your Name';
          return null;
        },
        controller: _nameCtrl,
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

  Widget passInput1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Confirm Password: ',
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

  Widget signupbtn(context) {
    return ElevatedButton(
      onPressed: () => performLogin(context),
      child: Text(
        'Sign up',
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
    String name = _nameCtrl.text;
    String email = _emailCtrl.text;
    String pass = _passCtrl.text;
    print('hi');
    print('$name,$email,$pass');

    if (_fKey.currentState.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);
        User _currentUser = userCredential.user;
        _currentUser.sendEmailVerification();
        print("hey harsh");

        storeUserDetails(context, _currentUser.uid, name, email);
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
        Text('Want to Login now?'),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_LOGIN);
            //function
          },
          child: Text(
            'Login',
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

  void storeUserDetails(context, String uid, String name, String email) async {
    Map<String, dynamic> userDetails = {
      "name": name,
      "email": email,
      "desc": "Nothing to share at moment",
      "image": "",
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userDetails)
        .then((_) {
      notifyUser(context, 'User Registerd');
      Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_LOGIN);
    }).catchError((onError) => notifyUser(context, onError));
  }
}
