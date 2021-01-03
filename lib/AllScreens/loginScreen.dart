import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go/AllScreens/registrationScreen.dart';
import 'package:go/AllWidgets/progressDialog.dart';
import 'package:go/main.dart';

import 'mainScreen.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  static const String idScreen = "loginScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 35.0,
                ),
                Center(
                  child: Image(
                    image: AssetImage(
                      "images/logo.png",
                    ),
                    width: 390.0,
                    height: 250.0,
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 1.0,
                ),
                Text(
                  "Login As A Rider",
                  style: TextStyle(fontFamily: "Brand Bold", fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            hintText: "123@example.com",
                            hintStyle: TextStyle(
                                fontSize: 14.0, fontFamily: "Brand Bold"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: "Brand Bold"),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordTextEditingController,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontSize: 12.0, fontFamily: "Brand Bold"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: "Brand Bold"),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@")) {
                            displayToastMessage(
                                "Email Address is not valid", context);
                          } else if (passwordTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Password is mandatory", context);
                          } else {
                            loginAndAuthenticate(context);
                          }
                        },
                        color: Colors.yellow,
                        textColor: Colors.white,
                        child: Container(
                          width: 280.0,
                          height: 45.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      // Route route = new MaterialPageRoute(
                      //     builder: (c) => RegistrationScreen());
                      // Navigator.pushReplacement(context, route);
                      Navigator.pushNamedAndRemoveUntil(context,
                          RegistrationScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      "New User?Register Here.",
                      style: TextStyle(fontFamily: "Brand Bold"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticate(BuildContext context) async {
    showDialog(context: context,barrierDismissible: false,builder: (c)=>ProgressDialog(message:"Authenticating...Please wait!!"));
    final User user = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errorMessage) {
              Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              content: Text("Error: " + errorMessage.toString()),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontFamily: "Brand Bold"),
                  ),
                  color: Colors.yellow,
                ),
              ],
            );
          });
    }))
        .user;

    if (user != null) {
      userRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Logged in successfully!", context);
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (c) {
                return AlertDialog(
                  content: Text("Error: No record exists for this user!"),
                  actions: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(fontFamily: "Brand Bold"),
                      ),
                      color: Colors.yellow,
                    ),
                  ],
                );
              });
        }
      });
    } else {
      Navigator.pop(context);
      _firebaseAuth.signOut();
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              content: Text("Error: No record exists for this user!"),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontFamily: "Brand Bold"),
                  ),
                  color: Colors.yellow,
                ),
              ],
            );
          });
    }
  }
}
