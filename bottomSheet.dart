import 'package:flutter/material.dart';
import 'consts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'credential.dart';
import 'master.dart';

class editor extends StatefulWidget {
  Map data;
  String Key;
  editor({this.data, this.Key});
  @override
  _editorState createState() => _editorState();
}

class _editorState extends State<editor> {
  String s = "";
  TextEditingController ted; //= TextEditingController();
  @override
  void initState() {
    ted = TextEditingController(text: widget.data['description']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      child: Column(
        children: [
          spacer,
          Center(
            child: Text(
              "Event Editor",
              style: TextStyle(fontSize: 35.0, color: textcolor),
            ),
          ),
          spacer,
          Text(
            "Date-:" +
                widget.data['dd'].toString() +
                "/" +
                widget.data['mm'].toString() +
                "/" +
                widget.data['yy'].toString(),
            style: TextStyle(color: secondary, fontSize: 25.0),
          ),
          SizedBox(height: 20.0),
          Container(
              height: 45.0,
              width: 300.0,
              decoration: BoxDecoration(
                border: Border.all(color: secondary, width: 3.0),
              ),
              child: TextField(
                controller: ted,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (val) {
                  s = val;
                },
                style: TextStyle(fontSize: 25.0),
              )),
          SizedBox(height: 20.0),
          Row(
            children: [
              SizedBox(width: 10.0),
              Expanded(
                child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      "Done",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    fillColor: secondary,
                    onPressed: () async {
                      await editDatabase(s, widget.Key, false);
                      //Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => master()),
                      );
                    }),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      "Delete",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    fillColor: secondary,
                    onPressed: () async {
                      bool ans = await confirm(context, "Accept",
                          "Do you wish to permanently delete this event?");
                      if (ans) {
                        await editDatabase(s, widget.Key, true);
                        //Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => master()),
                        );
                      }
                    }),
              ),
              SizedBox(width: 10.0),
            ],
          ),
        ],
      ),
    );
  }

  void editDatabase(String s, String key, bool delete) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference myRef =
        database.reference().child(credentials.userid).child('Events');
    DataSnapshot snapshot = await myRef.child(key).once();
    Map<String, String> x;
    if (delete)
      x = {
        'dd': null,
        'mm': null,
        'yy': null,
        'description': null,
      };
    else
      x = {
        'dd': snapshot.value['dd'],
        'mm': snapshot.value['mm'],
        'yy': snapshot.value['yy'],
        'description': s,
      };
    myRef.child(key).update(x);
    masterState ob = masterState();
    await ob.review();
  }
}
