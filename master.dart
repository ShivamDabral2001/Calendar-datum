import 'dart:async';
import 'package:datum/credential.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'backend.dart';
import 'consts.dart';
import 'addEvent.dart';
import 'bottomSheet.dart';
import 'drawer.dart';

TableRow blankrow = TableRow(children: [
  for (int i = 0; i <= 6; i++)
    Center(
        child: SizedBox(
      height: 12.0,
    )),
]);

class master extends StatefulWidget {
  @override
  masterState createState() => masterState();
}

class masterState extends State<master> {
  int m = 0, y = 0, d = 0, date, month, year, max = 0;
  String wday = "";
  Query info;
  CalRow ob = CalRow();
  void setMax(int m, int y) {
    if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12)
      max = 31;
    else if (m == 2)
      max = 28;
    else
      max = 30;
    if (((y % 4 == 0 && y % 100 != 0) || y % 400 == 0) && m == 2) max++;
  }

  void initState() {
    var fdate = DateTime.now();
    date = fdate.day;
    month = fdate.month;
    year = fdate.year;
    m = month;
    y = year;
    wday = weekdays[fdate.weekday - 1];
    d = ob.getFirstDay(m, y);
    setMax(m, y);
    super.initState();
    ob.findEvents();
    review();
    Timer(Duration(seconds: 2), () {
      setState(() {});
    });
  }

  void refresh() {
    setState(() {});
  }

  void review() {
    info = FirebaseDatabase.instance
        .reference()
        .child(credentials.userid)
        .child('Events');
    ob.findEvents();
    ob.findDates(m);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: primary,
          drawer: myDrawer(),
          floatingActionButton: FloatingActionButton(
              backgroundColor: secondary,
              child: Icon(Icons.add, color: primary, size: 35.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventPage()),
                );
              }),
          body: Column(children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Builder(
                    builder: (context) => GestureDetector(
                        child: Icon(
                          Icons.menu,
                          size: 35.0,
                          color: secondary,
                        ),
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        }),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    child: Text(
                      " $wday, $date ${months[month - 1]} $year",
                      style: TextStyle(fontSize: 20.0, color: textcolor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Icon(
                      Icons.calendar_today,
                      size: 35.0,
                      color: secondary,
                    ),
                    onTap: () {
                      setState(() {
                        m = month;
                        y = year;
                        d = ob.getFirstDay(m, y);
                        setMax(m, y);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),

            //***************End of top bar****************

            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30.0,
                    color: secondary,
                  ),
                  onTap: () {
                    setState(() {
                      m = m - 1;
                      if (m < 1) {
                        m = 12;
                        y = y - 1;
                      }
                      d = ob.getFirstDay(m, y);
                      setMax(m, y);
                      review();
                    });
                  },
                ),
                Container(
                  child: Text(
                    "   ${months[m - 1]} $y   ",
                    style: TextStyle(fontSize: 22.0, color: textcolor),
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 30.0,
                    color: secondary,
                  ),
                  onTap: () {
                    setState(() {
                      m = m + 1;
                      if (m > 12) {
                        m = 1;
                        y = y + 1;
                      }
                      d = ob.getFirstDay(m, y);
                      setMax(m, y);
                      review();
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),

            //***************End of month bar****************

            Table(
              children: [
                TableRow(children: [
                  Cell(value: "Sun", colour: red),
                  Cell(value: "Mon", colour: pink),
                  Cell(value: "Tues", colour: pink),
                  Cell(value: "Wed", colour: pink),
                  Cell(value: "Thurs", colour: pink),
                  Cell(value: "Fri", colour: pink),
                  Cell(value: "Sat", colour: pink),
                ]),
                TableRow(children: ob.genRows(d, m, y, max)),
                TableRow(children: ob.genRows(d + 7, m, y, max)),
                TableRow(children: ob.genRows(d + 14, m, y, max)),
                TableRow(children: ob.genRows(d + 21, m, y, max)),
                TableRow(children: ob.genRows(d + 28, m, y, max)),
                TableRow(children: ob.genRows(d + 35, m, y, max)),
              ],
            ),

            //***********End of Table**************

            Container(
              child: Text(
                "Events",
                style: TextStyle(
                  fontSize: 23.0,
                  color: textcolor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Flexible(
              child: FirebaseAnimatedList(
                query: info.orderByChild('dd'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map eventdetails = snapshot.value;
                  String key = snapshot.key;
                  return int.parse(eventdetails['mm']) == m
                      ? EventTile(details: eventdetails, Key: key)
                      : Container();
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class EventTile extends StatefulWidget {
  Map details;
  String Key;
  EventTile({this.details, this.Key});
  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) =>
                editor(data: widget.details, Key: widget.Key));
        masterState ob = masterState();
        ob.review();
      },
      leading: Container(
        height: 50.0,
        width: 70.0,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                color: secondary,
              ),
              child: Text(
                "${widget.details['dd'].toString()}",
                style: TextStyle(color: textcolor, fontSize: 20.0),
              ),
            ),
            SizedBox(width: 3.0),
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                color: secondary,
              ),
              child: Text(
                "${widget.details['mm'].toString()}",
                style: TextStyle(color: textcolor, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        "${widget.details['description'].toString()}",
        style: TextStyle(color: textcolor, fontSize: 17.0),
      ),
    );
  }
}
