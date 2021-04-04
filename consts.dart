import 'package:flutter/material.dart';

//****Temporary*****
var darkMode = false;
Color primary = Colors.white;
Color secondary = Colors.blueAccent;
Color textcolor = Colors.black;
//**************
const nblue = Color(0xFF4A5F74);
const tblue = Color(0xFFC2F1DB);
Color pink = Color(0xFFEB1555);
Color violet = Color(0xFF111328);
const red = Color(0xFFF70036);
const spacer = SizedBox(
  height: 20.0,
);
const List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
const List<String> weekdays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];
//TODO:Add fdate=DateTime.now()

void changeColor() {
  if (darkMode) {
    primary = violet;
    secondary = pink;
    textcolor = Colors.white;
  } else {
    primary = Colors.white;
    secondary = Colors.blueAccent;
    textcolor = Colors.black;
  }
}

Future<bool> confirm(BuildContext context, String title, String prompt) async {
  var alertdialog = AlertDialog(
    title: Center(
        child: Text(
      title, //"Accept",
      style: TextStyle(color: textcolor),
    )),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    backgroundColor: primary,
    content: Text(
      prompt, //"Do you wish to permanently delete this event?",
      style: TextStyle(color: textcolor, fontSize: 18.0),
    ),
    actions: <Widget>[
      FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child:
              Text("Yes", style: TextStyle(color: secondary, fontSize: 16.0))),
      FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child:
              Text("No", style: TextStyle(color: secondary, fontSize: 16.0))),
    ],
  );
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertdialog;
      });
}
