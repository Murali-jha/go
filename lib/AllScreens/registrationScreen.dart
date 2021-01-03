import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go/AllScreens/loginScreen.dart';
import 'package:go/AllScreens/mainScreen.dart';
import 'package:go/AllWidgets/progressDialog.dart';
import 'package:go/main.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "registrationScreen";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

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
                  "Register As A Rider",
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
                        height: 10.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: nameTextEditingController,
                        decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle:
                                TextStyle(fontSize: 16.0, color: Colors.black,fontFamily: "Brand Bold"),
                            hintText: "John",
                            hintStyle: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        style: TextStyle(fontSize: 14.0,color: Colors.black,fontFamily: "Brand Bold"),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:
                                TextStyle(fontSize: 16.0, color: Colors.black,fontFamily: "Brand Bold"),
                            hintText: "123@example.com",
                            hintStyle: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        style: TextStyle(fontSize: 14.0,color: Colors.black,fontFamily: "Brand Bold"),                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneTextEditingController,
                        decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle:
                                TextStyle(fontSize: 16.0, color: Colors.black,fontFamily: "Brand Bold"),
                            hintText: "6302892042",
                            hintStyle: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                        style: TextStyle(fontSize: 14.0,color: Colors.black,fontFamily: "Brand Bold"),                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordTextEditingController,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                TextStyle(fontSize: 16.0, color: Colors.black,fontFamily: "Brand Bold"),
                            hintText: "Password",
                            hintStyle: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        style: TextStyle(fontSize: 14.0,color: Colors.black,fontFamily: "Brand Bold"),                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (nameTextEditingController.text.length < 4) {
                            displayToastMessage(
                                "Name must be atLeast 4 characters", context);
                          } else if (!emailTextEditingController.text
                              .contains("@")) {
                            displayToastMessage(
                                "Email Address is not valid", context);
                          } else if (phoneTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Phone Number is mandatory", context);
                          } else if (passwordTextEditingController.text.length <
                              6) {
                            displayToastMessage(
                                "Password should contains atLeast 6 characters",
                                context);
                          } else {
                            registerNewUser(context);
                          }
                        },
                        color: Colors.yellow,
                        textColor: Colors.white,
                        child: Container(
                          width: 280.0,
                          height: 45.0,
                          child: Center(
                            child: Text(
                              "Register",
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
                      // Route route =
                      //     new MaterialPageRoute(builder: (c) => LoginScreen());
                      // Navigator.pushReplacement(context, route);
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      "Already Registered?Login Here",
                      style: TextStyle(fontFamily: "Brand Bold"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(context: context,barrierDismissible: false,builder: (c)=>ProgressDialog(message:"Registering...Please wait!!"));
    final User user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
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
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
      };
      userRef.child(user.uid).set(userDataMap);
      displayToastMessage(
          "Congratulations your account has been created!", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    }
    else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              content: Text("Error: New User Account has not been created"),
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

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
