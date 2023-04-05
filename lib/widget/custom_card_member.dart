// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_airqualitymonitor/pages/station.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCardMember extends StatefulWidget {
  const CustomCardMember({
    Key? key,
    required this.id,
    required this.name,
    required this.lastdate,
    required this.lasttime,
    required this.pm01,
    required this.pm25,
    required this.pm10,
    required this.co,
    required this.co2,
    required this.no2,
    required this.temp,
    required this.humid,
    required this.light,
  }) : super(key: key);

  final String id;
  final String name;
  final String lastdate;
  final String lasttime;
  final int pm01, pm25, pm10, co, co2, no2, temp, humid, light;

  @override
  State<CustomCardMember> createState() => _CustomCardMemberState();
}

class _CustomCardMemberState extends State<CustomCardMember> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.all(miniSpacer + 6),
      decoration: BoxDecoration(
        color: white,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        miniWidget(widget.name, "assets/bulletin-board.svg", textColor),
                        SizedBox(height: miniSpacer),
                        miniWidget("วันที่อัพเดตล่าสุด ${widget.lastdate}", "assets/calender.svg", textColor),
                        SizedBox(height: miniSpacer),
                        miniWidget("เวลาที่อัพเดตล่าสุด ${widget.lasttime}", "assets/clock.svg", textColor),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: miniSpacer),
          Divider(
            indent: 10,
            endIndent: 10,
            thickness: 0.8,
            color: Colors.grey,
          ),
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 4.0, // space between the containers
              runSpacing: 4.0, // space between the lines
              children: [
                poll(size, "PM1", widget.pm01),
                poll(size, "PM2.5", widget.pm25),
                poll(size, "PM10", widget.pm10),
                poll(size, "CO", widget.co),
                poll(size, "CO2", widget.co2),
                poll(size, "NO2", widget.no2),
              ],
            ),
          ),
          SizedBox(height: miniSpacer),
          InkResponse(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Station(
                    id: widget.id,
                    name: widget.name,
                    lastdate: widget.lastdate,
                    lasttime: widget.lasttime,
                  ),
                ),
              );
            },
            child: Container(
              width: size.width,
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: textColor.withOpacity(.4),
                borderRadius: borderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "รายละเอียด",
                    style: TextStyle(fontSize: 14, color: black),
                  ),
                  SvgPicture.asset("assets/arrow-right.svg", height: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: miniSpacer),
          if (role)
            Row(
              children: [
                Flexible(
                  child: InkResponse(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("ลบสถานี"),
                            content: Text("คุณยืนยันที่จะลบสถานีออกจากรายการสถานีหรือไม่?"),
                            actions: <Widget>[
                              // OK Button
                              TextButton(
                                child: Text(
                                  "ยืนยัน",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  CollectionReference allstationCols = FirebaseFirestore.instance.collection('allstation');
                                  CollectionReference currentCols = FirebaseFirestore.instance.collection('currentdata');
                                  Navigator.of(context).pop();

                                  allstationCols.doc(widget.id).delete().then((value) => print("allstationCols ${widget.id} Deleted")).catchError((error) => print("Failed to delete user: $error"));
                                  currentCols.doc(widget.id).delete().then((value) => print("currentCols ${widget.id} Deleted")).catchError((error) => print("Failed to delete user: $error"));
                                },
                              ),
                              // Cancel Button
                              TextButton(
                                child: Text(
                                  "ยกเลิก",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onPressed: () {
                                  // Perform action on Cancel press
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(.4),
                        borderRadius: borderRadius,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/trash.svg", height: 20),
                          SizedBox(width: miniSpacer),
                          Text(
                            "ลบสถานี",
                            style: TextStyle(fontSize: 14, color: black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: miniSpacer),
                Flexible(
                  child: Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(.4),
                      borderRadius: borderRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/edit.svg", height: 20),
                        SizedBox(width: miniSpacer),
                        Text(
                          "แก้ไขสถานี",
                          style: TextStyle(fontSize: 14, color: black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  IntrinsicWidth miniWidget(String text, String svg, Color color) {
    return IntrinsicWidth(
      child: Container(
        height: 30,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: miniSpacer),
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.2),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svg, height: 18),
            SizedBox(width: miniSpacer),
            Text(text, style: TextStyle(color: black, fontSize: 12.0)),
          ],
        ),
      ),
    );
  }

  Container poll(Size size, String name, int value) {
    return Container(
      width: size.width * .12,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: miniSpacer),
          Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(name, style: TextStyle(fontSize: 12, color: black)),
          ),
          SizedBox(height: miniSpacer),
          Container(
            color: Colors.transparent,
            child: Container(
              width: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: textColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("$value", style: TextStyle(fontSize: 12, color: black)),
            ),
          ),
          SizedBox(height: miniSpacer),
        ],
      ),
    );
  }
}
