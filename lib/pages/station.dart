// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_airqualitymonitor/widget/bottom_clipper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Station extends StatefulWidget {
  const Station({
    super.key,
    required this.id,
    required this.name,
    required this.lastdate,
    required this.lasttime,
  });
  final String id;
  final String name;
  final String lastdate;
  final String lasttime;
  @override
  State<Station> createState() => _StationState();
}

class _StationState extends State<Station> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: size.width,
                  height: kToolbarHeight / 2,
                  color: secondary,
                ),
                Container(
                  width: size.width,
                  height: kToolbarHeight,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: secondary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // NMAE STATION
            SizedBox(
              width: size.width,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipPath(
                        clipper: BottomClipper(),
                        child: Container(
                          width: size.width,
                          height: 150.0,
                          decoration: const BoxDecoration(
                            color: secondary,
                          ),
                        ),
                      ),
                      Positioned(
                        top: smallSpacer,
                        child: Column(
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              'อัพเดตล่าสุด ${widget.lastdate} | ${widget.lasttime}',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: smallSpacer),
            //TEMP HUMID LIGHT
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  blogshow("30"),
                  blogshow("30"),
                  blogshow("30"),
                ],
              ),
            ),
            //VALUE
            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: smallSpacer - 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.width * .05),
                  Text(
                    'ค่าปริมาณมลพิษ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(height: size.width * .05),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 4, // space between the containers
                    runSpacing: 4, // space between the lines
                    children: [
                      linearbars("PM 1", "10", "µg/m³"),
                      linearbars("PM 2.5", "15", "µg/m³"),
                      linearbars("PM 10", "25", "µg/m³"),
                      linearbars("CO", "2", "ppb"),
                      linearbars("CO2", "4", "ppb"),
                      linearbars("NO2", "6", "ppb"),
                    ],
                  ),
                  SizedBox(height: size.width * .05),
                  //กราฟมลพิษ
                  Text(
                    'กราฟค่าปริมาณมลพิษ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(height: size.width * .05),

                  Container(
                    width: size.width,
                    height: size.width * .4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                  ),

                  //เกี่ยวกับสถานะไฟ
                  SizedBox(height: size.width * .05),
                  Text(
                    'สถานะการใช้งานเสาไฟและไฟ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(height: size.width * .05),
                  Row(
                    children: [
                      SvgPicture.network(
                        'https://www.svgrepo.com/show/112190/lamp.svg',
                        height: 150,
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สถานะการทำงานของดวงไฟ',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'สถานะ : ',
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  Text(
                                    'ปิดอยู่',
                                    style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                'จำนวน Volt : 12V',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                              Text(
                                'จำนวน Watt : 4W',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                              Text(
                                'เปิดทำงานมาแล้ว : 10 วัน',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * .05),
                  Container(
                    width: size.width,
                    height: size.width * .4,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: size.width * .05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }

  Container linearbars(String name, String value, String type) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .425,
      height: 60,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: miniSpacer),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      type,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: size.width * .02),
          LinearPercentIndicator(
            alignment: MainAxisAlignment.start,
            lineHeight: 12,
            percent: int.parse(value) / 100,
            animation: true,
            animationDuration: 2500,
            barRadius: const Radius.circular(8),
            progressColor: Colors.blue.shade800,
            backgroundColor: Colors.blue.shade300,
            curve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  Container blogshow(String value) {
    return Container(
      width: 100,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 10,
          )
        ],
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}
