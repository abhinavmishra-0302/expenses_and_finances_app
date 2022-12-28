import 'package:expenses_and_finances/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mobileController = TextEditingController();
  final codeController = TextEditingController();

  bool codeSent = false;
  late String verificationId;
  late FirebaseAuth auth;

  Future mobileAuthHandler() async {
    if (mobileController.text.length == 10) {
      print("+91${mobileController.text}");
      FirebaseAuth auth = FirebaseAuth.instance;
      this.auth = auth;
      await auth.verifyPhoneNumber(
          phoneNumber: "+91${mobileController.text}",
          verificationCompleted: (PhoneAuthCredential credential) {
            auth.signInWithCredential(credential);
            Fluttertoast.showToast(msg: "Signed in");
          },
          verificationFailed: (FirebaseAuthException e) {
            Fluttertoast.showToast(msg: e.toString());
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              codeSent = true;
              this.verificationId = verificationId;
              print("+91${mobileController.text}");
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } else {
      Fluttertoast.showToast(msg: "Enter valid mobile number");
    }
  }

  verifyCodeHandler(String verificationId, FirebaseAuth auth) {
    final code = codeController.text;

    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);

    auth.signInWithCredential(credential).whenComplete(() {
      Fluttertoast.showToast(msg: "Sign in successful");
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyHomePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login or Register"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              "assets/images/login.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: codeSent
                ? TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: codeController,
                    decoration: InputDecoration(
                        labelText: "Enter code sent",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.amberAccent))),
                  )
                : TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: mobileController,
                    decoration: InputDecoration(
                        labelText: "Enter your phone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.amberAccent))),
                  ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: codeSent
                  ? ElevatedButton(
                      onPressed: () {
                        verifyCodeHandler(verificationId, auth);
                      },
                      child: Text("Sign in"))
                  : ElevatedButton(
                      onPressed: mobileAuthHandler, child: Text("Send code"))),
        ],
      ),
    );
  }
}
