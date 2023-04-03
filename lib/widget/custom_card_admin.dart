// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCardAdmin extends StatefulWidget {
  const CustomCardAdmin({
    Key? key,
    required this.keys,
    required this.name,
    required this.lastdate,
    required this.lasttime,
    required this.pm01,
    required this.pm25,
    required this.pm10,
    required this.co,
    required this.co2,
    required this.no2,
  }) : super(key: key);

  final String keys;
  final String name;
  final String lastdate;
  final String lasttime;
  final int pm01;
  final int pm25;
  final int pm10;
  final int co;
  final int co2;
  final int no2;

  @override
  State<CustomCardAdmin> createState() => _CustomCardAdminState();
}

class _CustomCardAdminState extends State<CustomCardAdmin> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.all(miniSpacer),
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
                        miniWidget(widget.keys, "assets/key.svg", textColor),
                        SizedBox(height: miniSpacer),
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
              Container(
                width: size.width * .13,
                margin: EdgeInsets.only(right: miniSpacer),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: borderRadius),
                        child: SvgPicture.asset(
                          "assets/trash.svg",
                          height: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: miniSpacer),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: borderRadius),
                      child: SvgPicture.asset(
                        "assets/edit.svg",
                        height: 24,
                      ),
                    ),
                    SizedBox(height: miniSpacer),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: borderRadius),
                      child: SvgPicture.asset(
                        "assets/arrow-right.svg",
                        height: 24,
                      ),
                    ),
                  ],
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
          color: textColor.withOpacity(0.4),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svg, height: 18),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(color: black, fontSize: 12.0),
            ),
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
