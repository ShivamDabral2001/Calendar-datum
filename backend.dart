import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'consts.dart';
import 'credential.dart';

class Cell extends StatelessWidget {
  final String value;
  final Color colour;
  final Color bcolour;
  final int eventCount;
  Cell({this.value, this.colour, this.bcolour, this.eventCount = 0});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: bcolour,
              shape: BoxShape.circle,
            ),
            child: Text(
              value,
              style: TextStyle(
                  color: colour,
                  fontSize: 17.0,
                  fontWeight:
                      colour == primary ? FontWeight.w600 : FontWeight.w400),
            ),
          ),
          eventCount != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= eventCount % 3; i++)
                      Container(
                        padding: EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          backgroundColor: secondary,
                          radius: 3.0,
                        ),
                      ),
                  ],
                )
              : SizedBox(
                  height: 10.0,
                ),
        ],
      ),
    );
  }
}

class eventClass {
  int dd = 0, mm = 0;
  eventClass(int d, int m) {
    dd = d;
    mm = m;
  }
}

class CalRow {
  List<Cell> RowCell = [];
  List<eventClass> allEvents = [];
  var datesForThisMonth = new List(31);

  void findDates(int m) {
    for (int i = 0; i < 31; i++) datesForThisMonth[i] = 0;
    for (var i in allEvents) if (i.mm == m) datesForThisMonth[i.dd - 1]++;
  }

  List<Cell> genRows(int d, int m, int y, int max) {
    var fdate = DateTime.now();
    findDates(m);
    int date = fdate.day;
    int month = fdate.month;
    int year = fdate.year;
    RowCell = [];
    int k = 0;
    for (int i = 0; i < 7; i++) {
      if (d + i <= max && d + i >= 1) {
        k = datesForThisMonth[d + i - 1];
        if (date == (d + i) && month == m && year == y)
          RowCell.add(Cell(
              value: (d + i).toString(),
              colour: primary,
              eventCount: k,
              bcolour: secondary)); //Present date
        else if (i == 0)
          RowCell.add(Cell(
            value: (d + i).toString(),
            colour: red,
            eventCount: k,
          )); //Sunday
        else
          RowCell.add(Cell(
            value: (d + i).toString(),
            colour: textcolor,
            eventCount: k,
          )); //Others
      } else
        RowCell.add(Cell(
          value: " ",
        ));
    }
    return RowCell;
  }

  int getFirstDay(int m, int y) {
    int days = 0;
    days = (y - 1600) * 365;
    days = days + ((y - 1 - 1600) / 4).floor();
    days = days + 1;
    days += (((y - 1) - 1600) / 400).floor() - (((y - 1) - 1600) / 100).floor();
    if (y == 1600) days = 0;
    if (m >= 2) days = days + 31;
    if (m >= 3) days += 28;
    if (m >= 4) days += 31;
    if (m >= 5) days += 30;
    if (m >= 6) days += 31;
    if (m >= 7) days += 30;
    if (m >= 8) days += 31;
    if (m >= 9) days += 31;
    if (m >= 10) days += 30;
    if (m >= 11) days += 31;
    if (m == 12) days += 30;
    if (((y % 4 == 0 && y % 100 != 0) || y % 400 == 0) && m >= 3) days++;
    days = days % 7;
    List start = [-5, 1, 0, -1, -2, -3, -4];
    return start[days];
    //String wd[]={"Sat","Sun","Mon","Tues","Wed","Thurs","Fri"}; i.e jan 1 1600 was sat
    //System.out.println(wd[days]);
  }

  void findEvents() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference myRef =
        database.reference().child(credentials.userid).child('Events');
    myRef.once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      allEvents.clear();
      for (var key in keys) {
        allEvents.add(eventClass(
            int.parse(values[key]['dd']), int.parse(values[key]['mm'])));
      }
    });
  }
}
