import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_airqualitymonitor/utils/TotalResult.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ShowStation1 extends StatefulWidget {
  const ShowStation1({
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
  State<ShowStation1> createState() => _ShowStationState();
}

class _ShowStationState extends State<ShowStation1> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                  color: black,
                ),
              ),
            ),
            const Text(
              "",
              style: TextStyle(fontSize: 17, color: white),
            ),
            IconButton(
              onPressed: () {},
              icon: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 22,
                    color: black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: kToolbarHeight + smallSpacer - miniSpacer),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, smallSpacer, padding, smallSpacer),
            child: Container(
              width: size.width,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(color: black, fontSize: 18.0),
                      ),
                      SizedBox(height: miniSpacer),
                      Text(
                        "อัพเดตล่าสุด ${widget.lastdate} ${widget.lasttime}",
                        style: const TextStyle(color: black, fontSize: 14.0),
                      ),
                      SizedBox(height: miniSpacer + 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          miniWidget(50, "${25} °C", "assets/thermometer.svg", white, 24),
                          SizedBox(width: miniSpacer),
                          miniWidget(50, "${50} %", "assets/blackdroplet.svg", white, 24),
                          SizedBox(width: miniSpacer),
                          miniWidget(50, "${120} %", "assets/sun-behind-small-cloud.svg", white, 24),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
            alignment: Alignment.centerLeft,
            child: const Text(
              "ปริมาณมลพิษ",
              style: TextStyle(color: black, fontSize: 14.0),
            ),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.fromLTRB(padding, miniSpacer + 6, padding, miniSpacer + 6),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 0, // space between the containers
              runSpacing: 0, // space between the lines
              children: <Widget>[
                dpPollution(size, "PM 1", "µg/m³", 24),
                dpPollution(size, "PM 2.5", "µg/m³", 12),
                dpPollution(size, "PM 10", "µg/m³", 4),
                dpPollution(size, "CO", "µg/m³", 5),
                dpPollution(size, "CO2", "µg/m³", 23),
                dpPollution(size, "NO2", "µg/m³", 18),
              ],
            ),
          ),
          SizedBox(height: miniSpacer),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "กราฟแสดงมลพิษ",
                  style: TextStyle(fontSize: 14, color: black),
                ),
                Container(
                  width: 130,
                  height: 35,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: const Text('2023-03-03'),
                  // child: DropdownButton(
                  //   // Initial Value
                  //   value: dropdownvalue,
                  //   // Down Arrow Icon
                  //   icon: const Icon(Icons.keyboard_arrow_down),

                  //   // Array list of items
                  //   items: stringValues.map((String items) {
                  //     return DropdownMenuItem(
                  //       value: items,
                  //       child: Text(
                  //         items,
                  //         style: const TextStyle(fontSize: 14),
                  //       ),
                  //     );
                  //   }).toList(),
                  //   // After selecting the desired option,it will
                  //   // change button value to selected value
                  //   elevation: 8,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       dropdownvalue = newValue!;
                  //     });
                  //   },
                  // ),
                ),
              ],
            ),
          ),
          SizedBox(height: miniSpacer),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, miniSpacer, padding, miniSpacer),
            child: Container(
              width: size.width,
              height: 200,
              padding: EdgeInsets.fromLTRB(padding, padding, padding, miniSpacer),
              decoration: BoxDecoration(
                color: white,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(0.12),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                      tooltipMargin: 0,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String text;
                        switch (group.x) {
                          case 0:
                            text = '00:00';
                            break;
                          case 1:
                            text = '01:00';
                            break;
                          case 2:
                            text = '02:00';
                            break;
                          case 3:
                            text = '03:00';
                            break;
                          case 4:
                            text = '04:00';
                            break;
                          case 5:
                            text = '05:00';
                            break;
                          case 6:
                            text = '06:00';
                            break;
                          case 7:
                            text = '07:00';
                            break;
                          case 8:
                            text = '08:00';
                            break;
                          case 9:
                            text = '09:00';
                            break;
                          case 10:
                            text = '10:00';
                            break;
                          case 11:
                            text = '11:00';
                            break;
                          case 12:
                            text = '12:00';
                            break;
                          case 13:
                            text = '13:00';
                            break;
                          case 14:
                            text = '14:00';
                            break;
                          case 15:
                            text = '15:00';
                            break;
                          case 16:
                            text = '16:00';
                            break;
                          case 17:
                            text = '17:00';
                            break;
                          case 18:
                            text = '18:00';
                            break;
                          case 19:
                            text = '19:00';
                            break;
                          case 20:
                            text = '20:00';
                            break;
                          case 21:
                            text = '21:00';
                            break;
                          case 22:
                            text = '22:00';
                            break;
                          case 23:
                            text = '23:00';
                            break;
                          default:
                            throw Error();
                        }
                        return BarTooltipItem(
                          '$text\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: (rod.toY - 1).toString(),
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(
                        () {
                          if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                        },
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            fontSize: 10,
                            color: black,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('00:00', style: style);
                              break;
                            case 4:
                              text = const Text('04:00', style: style);
                              break;
                            case 8:
                              text = const Text('08:00', style: style);
                              break;
                            case 12:
                              text = const Text('12:00', style: style);
                              break;
                            case 16:
                              text = const Text('16:00', style: style);
                              break;
                            case 20:
                              text = const Text('20:00', style: style);
                              break;
                            case 23:
                              text = const Text('23:00', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 16,
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: List.generate(24, (index) {
                    switch (index) {
                      case 0:
                        return makeGroupData(index, 5, isTouched: index == touchedIndex);
                      case 1:
                        return makeGroupData(index, 4, isTouched: index == touchedIndex);
                      case 2:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 3:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 4:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 5:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 6:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 7:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 8:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 9:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 10:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 11:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 12:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 13:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 14:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 15:
                        return makeGroupData(index, 8, isTouched: index == touchedIndex);
                      case 16:
                        return makeGroupData(index, 9, isTouched: index == touchedIndex);
                      case 17:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 18:
                        return makeGroupData(index, 8, isTouched: index == touchedIndex);
                      case 19:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 20:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 21:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 22:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      case 23:
                        return makeGroupData(index, 7, isTouched: index == touchedIndex);
                      default:
                        throw Error();
                    }
                  }),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
          SizedBox(height: miniSpacer),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "กราฟแสดงพลังงานของสถานี",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: black),
                ),
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [secondary, primary]), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "ชั่วโมง",
                        style: TextStyle(fontSize: 14, color: white),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: miniSpacer),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, miniSpacer, padding, miniSpacer),
            child: Container(
              width: size.width,
              height: 200,
              padding: EdgeInsets.fromLTRB(padding, padding, padding, miniSpacer),
              decoration: BoxDecoration(
                color: white,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(0.12),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: LineChart(
                workoutProgressData(),
              ),
            ),
          ),
          SizedBox(height: miniSpacer),
        ],
      ),
    );
  }

  Container miniWidget(double width, String text, String svg, Color color, double svgsize) {
    return Container(
      width: 95,
      height: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: miniSpacer),
          SvgPicture.asset(svg, height: svgsize),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: black,
              fontSize: 14.0,
            ),
          ),
          SizedBox(width: miniSpacer),
        ],
      ),
    );
  }

  Padding dpPollution(Size size, String nametype, String type, int value) {
    TotalResult result = getTotal(value, nametype);
    return Padding(
      padding: EdgeInsets.only(left: miniSpacer, right: miniSpacer, bottom: miniSpacer),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nametype,
                style: const TextStyle(
                  color: black,
                  fontSize: 14.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    "$value  ",
                    style: const TextStyle(
                      color: black,
                      fontSize: 14.0,
                    ),
                  ),
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
          SizedBox(height: miniSpacer),
          LinearPercentIndicator(
            alignment: MainAxisAlignment.start,
            width: size.width * .8,
            lineHeight: 12,
            percent: value / result.total,
            animation: true,
            animationDuration: 2500,
            barRadius: const Radius.circular(8),
            progressColor: result.progressColor,
            backgroundColor: result.backgroundColor,
            curve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  Row displayPolluatants(Size size, String nametype, String type, int value) {
    TotalResult result = getTotal(value, nametype);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: size.width * 0.15,
          height: 30,
          color: Colors.transparent,
          child: Text(
            nametype,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        IntrinsicWidth(
          child: Container(
            height: 30,
            color: Colors.transparent,
            child: LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              width: size.width * 0.45,
              lineHeight: 8,
              percent: value / result.total,
              animation: true,
              animationDuration: 2500,
              barRadius: const Radius.circular(8),
              progressColor: result.progressColor,
              backgroundColor: result.backgroundColor,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 30,
            width: 80,
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$value"),
                Text(
                  type,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 8,
    List<int> showTooltips = const [],
  }) {
    barColor ??= barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.green : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(
                  color: Colors.green.shade800,
                )
              : const BorderSide(
                  color: Colors.white,
                ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: Colors.black.withOpacity(.2),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < 24; i++) {
      double yValue;
      switch (i) {
        case 0:
          yValue = 5;
          break;
        case 1:
          yValue = 6.5;
          break;
        case 2:
          yValue = 5;
          break;
        case 3:
          yValue = 7.5;
          break;
        case 4:
          yValue = 9;
          break;
        case 5:
          yValue = 11.5;
          break;
        case 6:
          yValue = 6.5;
          break;
        case 7:
          yValue = 8;
          break;
        case 8:
          yValue = 4;
          break;
        case 9:
          yValue = 12;
          break;
        case 10:
          yValue = 10;
          break;
        case 11:
          yValue = 9;
          break;
        case 12:
          yValue = 5;
          break;
        case 13:
          yValue = 8;
          break;
        case 14:
          yValue = 4;
          break;
        case 15:
          yValue = 8;
          break;
        case 16:
          yValue = 6;
          break;
        case 17:
          yValue = 5;
          break;
        case 18:
          yValue = 3;
          break;
        case 19:
          yValue = 12;
          break;
        case 20:
          yValue = 14;
          break;
        case 21:
          yValue = 5;
          break;
        case 22:
          yValue = 15;
          break;
        case 23:
          yValue = 20;
          break;
        default:
          throw Error();
      }
      groups.add(makeGroupData(i, yValue, isTouched: i == touchedIndex));
    }
    return groups;
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
          reservedSize: 40,
          getTitlesWidget: leftTitleWidgets,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 0,
    maxX: 12,
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
          show: true,
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
    case 2:
      text = '02:00';
      break;
    case 4:
      text = '04:00';
      break;
    case 6:
      text = '6:00';
      break;
    case 8:
      text = '8:00';
      break;
    case 10:
      text = '10:00';
      break;
    case 12:
      text = '12:00';
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
