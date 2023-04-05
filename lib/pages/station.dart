// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
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
  late String _selectedValue = '2023-00-00';
  final List<String> _dropdownValues = [];

  bool isLoading = false;

  Future<void> _getData() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collectionGroup('hourdata').get();
    final List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    for (var doc in docs) {
      _dropdownValues.add(doc.id);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      _getData().then(
        (value) {
          setState(() {
            _selectedValue = _dropdownValues[0];
          });
        },
      );
    }).then(
      (value) {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'กราฟค่าปริมาณมลพิษ',
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            DropdownButton<String>(
                              value: _selectedValue,
                              items: _dropdownValues.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue = value.toString(); // set the selected value to the variable
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: size.width * .05),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('hourdata').doc(_selectedValue).collection('0492393966').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            List<QueryDocumentSnapshot> stations = snapshot.data!.docs;

                            return Container(
                              width: size.width,
                              height: 200,
                              padding: EdgeInsets.fromLTRB(padding, padding, padding, miniSpacer),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: borderRadius,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  )
                                ],
                              ),
                              child: LineChart(
                                workoutProgressData(),
                              ),
                            );
                          },
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

LineChartData workoutProgressData() {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: false,
      horizontalInterval: 1,
      verticalInterval: 1,
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey,
          strokeWidth: 0.1,
        );
      },
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.black,
          strokeWidth: 0.1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 25,
          getTitlesWidget: leftTitleWidgets,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 0,
    maxX: 24,
    minY: 0,
    maxY: 4,
    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 0),
          FlSpot(1, 2),
          FlSpot(2, 2.5),
          FlSpot(3, 3),
          FlSpot(4, 2.5),
          FlSpot(5, 3.1),
          FlSpot(6, 2.5),
          FlSpot(7, 1.5),
          FlSpot(8, 2),
          FlSpot(9, 2.3),
          FlSpot(10, 2.5),
          FlSpot(11, 2.7),
          FlSpot(12, 3),
          FlSpot(13, 2),
          FlSpot(14, 2),
          FlSpot(15, 2.5),
          FlSpot(16, 3),
          FlSpot(17, 2.5),
          FlSpot(18, 3.1),
          FlSpot(19, 2.5),
          FlSpot(20, 1.5),
          FlSpot(21, 2),
          FlSpot(22, 2.3),
          FlSpot(23, 2.5),
        ],
        isCurved: true,
        gradient: const LinearGradient(
          colors: [
            onecolor,
            twocolor,
            thirdColor,
            fourthColor,
          ],
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              onecolor.withOpacity(.2),
              twocolor.withOpacity(.2),
              thirdColor.withOpacity(.2),
              fourthColor.withOpacity(.2),
            ],
          ),
        ),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
      ),
    ],
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 10,
    color: black,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = '0';
      break;
    case 1:
      text = '20';
      break;
    case 2:
      text = '60';
      break;
    case 3:
      text = '80';
      break;
    case 4:
      text = '100';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 10,
    color: black,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = '00:00';
      break;
    case 4:
      text = '02:00';
      break;
    case 8:
      text = '04:00';
      break;
    case 12:
      text = '6:00';
      break;
    case 16:
      text = '8:00';
      break;
    case 20:
      text = '10:00';
      break;
    case 24:
      text = '23:00';
      break;
    default:
      return Container();
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8,
    child: Text(text, style: style),
  );
}
