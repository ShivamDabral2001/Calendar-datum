import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'consts.dart';
import 'loginScreen.dart';

class start extends StatefulWidget {
  @override
  _startState createState() => _startState();
}

class _startState extends State<start> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            spacer,
            spacer,
            Center(
              child: CircleAvatar(
                radius: 150.0,
                backgroundColor: Colors.white,
                child: Image(
                  image: AssetImage("assets/cal.jpg"),
                ),
              ),
            ),
            spacer,
            Text(
              "Welcome to Datum!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w400),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
              child: Text(
                "A Simple Calendar Application that helps you manage events.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),

            spacer,
            //Text
            spacer,
            Builder(builder: (BuildContext context) {
              return RawMaterialButton(
                constraints: BoxConstraints(maxWidth: 300.0),
                fillColor: Colors.blueAccent,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get Started",
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login()),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
