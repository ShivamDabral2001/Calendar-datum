import 'package:datum/master.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'credential.dart';
import 'consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'loginScreen.dart';

class myDrawer extends StatefulWidget {
  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  String image = credentials.photoUrl;
  String name = credentials.name;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: primary,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: secondary),
              child: Column(
                children: [
                  ClipOval(
                    child: Image(
                      image: image == ""
                          ? AssetImage("assets/cal.jpg")
                          : NetworkImage(image),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CupertinoSwitch(
                  activeColor: pink,
                  value: darkMode,
                  onChanged: (bool val) {
                    darkMode = !darkMode;
                    changeColor();
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => master()),
                    );
                  }),
              title: Text(
                "Dark Mode",
                style: TextStyle(
                  color: textcolor,
                  fontSize: 20.0,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: secondary,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: textcolor,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                signout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void signout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    bool ans = await confirm(
        context, "Accept", "Do you wish to logout from this account?");
    if (ans == false) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
