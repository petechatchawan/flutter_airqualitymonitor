// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_airqualitymonitor/pages/profile_page.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_airqualitymonitor/widget/bottom_clipper.dart';
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
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Stack(
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
                      Icons.menu_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        Positioned(
          top: 80,
          child: SizedBox(
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
                        height: 200.0,
                        decoration: const BoxDecoration(
                          color: secondary,
                        ),
                      ),
                    ),
                    Positioned(
                      top: spacer,
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
        ),

        //TEMP HUMID LIGHT
        Positioned(
          top: 240,
          child: Container(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                blogshow(),
                blogshow(),
                blogshow(),
              ],
            ),
          ),
        ),

        Positioned(
          top: 300,
          child: Container(
            width: size.width,
            height: size.width,
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
                    Linearbars("PM 1", "10", "µg/m³"),
                    Linearbars("PM 2.5", "15", "µg/m³"),
                    Linearbars("PM 10", "25", "µg/m³"),
                    Linearbars("CO", "2", "ppb"),
                    Linearbars("CO2", "4", "ppb"),
                    Linearbars("NO2", "6", "ppb"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container Linearbars(String name, String value, String type) {
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

  Container blogshow() {
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
          'อุณภูมิ 30C',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}
