import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'getStarted.dart';
import 'master.dart';
import 'credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'backend.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: test(),
  ));
}

class test extends StatefulWidget {
  @override
  testState createState() => testState();
}

class testState extends State<test> with SingleTickerProviderStateMixin {
  AnimationController _ac;
  Animation _animation;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool hasUser = false;
  @override
  void initState() {
    _ac = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    isLoggedIn();
    _animation = CurvedAnimation(parent: _ac, curve: Curves.decelerate);
    _ac.forward();
    _ac.addListener(() {
      setState(() {
        if (_animation.value == 1.0) {
          pushPage();
        }
      });
    });
    super.initState();
  }

  void pushPage() {
    if (hasUser) {
      credentials ob = credentials(
          firebaseAuth.currentUser.displayName,
          firebaseAuth.currentUser.email,
          firebaseAuth.currentUser.photoURL,
          firebaseAuth.currentUser.uid);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => master()),
      );
    } else
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => start()),
      );
  }

  void isLoggedIn() {
    if (firebaseAuth.currentUser != null)
      hasUser = true;
    else
      hasUser = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Opacity(
            opacity: _animation.value,
            child: Image(
              image: AssetImage("assets/app_icon.png"),
              height: 200.0, //_animation.value * 200,
            ),
          ),
        ),
      ),
    );
  }
}
