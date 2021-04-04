import 'dart:async';

import 'package:datum/credential.dart';
import 'package:datum/master.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'consts.dart';
import 'backend.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int index = 0;
  DateTime currentValue;
  String d, y, mname, t;
  int day, year, month;
  String Edes = "";
  int dd, mm, yy;
  @override
  void initState() {
    var fdate = DateTime.now();
    day = fdate.day;
    month = fdate.month;
    year = fdate.year;
    d = day.toString();
    t = month.toString();
    y = year.toString();
    if (day < 10) d = "0" + d;
    if (month < 10) t = "0" + t;
    mname = months[month - 1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Text(
                "Add a Event",
                style: TextStyle(fontSize: 40.0, color: textcolor),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: 300.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: TextField(
                onChanged: (String value) {
                  Edes = value;
                },
                decoration: InputDecoration(
                  hintText: "Add Event Description",
                  hintStyle: TextStyle(color: secondary),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Select Date:",
              textAlign: TextAlign.left,
              style: TextStyle(color: secondary, fontSize: 30.0),
            ),
            SizedBox(height: 20.0),
            Container(
              width: 250.0,
              child: DateTimeField(
                initialValue: DateTime.now(),
                format: DateFormat("dd-MMMM-yyyy"),
                resetIcon: Icon(
                  Icons.cancel,
                  color: secondary,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: secondary,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Tap to enter date",
                  hintStyle: TextStyle(
                      color: secondary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400),
                  fillColor: primary,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                        color: secondary, width: 3.0, style: BorderStyle.solid),
                  ),
                ),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      //initialDate: DateTime(2020),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2023));
                },
                onChanged: (context) {
                  print(context);
                  d = context.toString().substring(8, 10);
                  y = context.toString().substring(0, 4);
                  t = context.toString().substring(5, 7);
                  mname = months[int.parse(t) - 1];
                  print(d + t + y);
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ButtonTheme(
              minWidth: 180.0,
              height: 40.0,
              child: RaisedButton(
                color: secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                onPressed: () async {
                  await addToDatabase(d, t, y, Edes);
                  //Navigator.pop(context, true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => master()),
                  );
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: textcolor, fontSize: 25.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> addToDatabase(
      String dd, String mm, String yy, String Event) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference myRef =
        database.reference().child(credentials.userid).child('Events');
    Map<String, String> info = {
      'dd': dd,
      'mm': mm,
      'yy': yy,
      'description': Event,
    };
    myRef.push().set(info);
    masterState ob = masterState();
    await ob.review();
    return true;
  }
}
