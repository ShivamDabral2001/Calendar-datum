import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'master.dart';
import 'credential.dart';
import 'consts.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            spacer,
            spacer,
            Center(child: Image(image: AssetImage("assets/app_icon.png"))),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  spacer,
                  Container(
                    height: 55.0,
                    width: 300.0,
                    padding: EdgeInsets.only(left: 8.0, right: 20.0),
                    margin: EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        labelText: "Username",
                        filled: true,
                        fillColor: Colors.white10,
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  spacer,
                  Container(
                    width: 300.0,
                    height: 55.0,
                    margin: EdgeInsets.only(left: 15.0),
                    padding: EdgeInsets.only(left: 8.0, right: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  spacer,
                  Container(
                    width: 300.0,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: RawMaterialButton(
                      fillColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onPressed: null,
                    ),
                  ),
                  spacer,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: RawMaterialButton(
                      constraints:
                          BoxConstraints(minWidth: 300.0, maxWidth: 300.0),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      fillColor: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Sign In With Google",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () => signin(),
                    ),
                  ),
                  spacer,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signin() async {
    GoogleSignInAccount gsacc = await googleSignIn.signIn();
    GoogleSignInAuthentication gsauth = await gsacc.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: gsauth.idToken, accessToken: gsauth.accessToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
    //googleSignIn.currentUser == null,
    if (gsacc == null)
      print(
          "NO USER NO USERNO USER NO USER NO USERNO USERNO USERvNO USERNO USERNO USERNO USERvvvNO USERNO USERNO USER");
    else
      print(gsacc.email);
    if (googleSignIn.currentUser != null) {
      credentials ob = credentials(googleSignIn.currentUser.displayName,
          googleSignIn.currentUser.email, googleSignIn.currentUser.photoUrl,
          firebaseAuth.currentUser.uid);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => master()),
      );
    }
  }
}
