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
  final List<double> data = [];

  bool isLoading = false;

  Future<void> _getData() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collectionGroup('hourdata').limit(3).get();
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
    Future.delayed(const Duration(seconds: 1), () {
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
          ? const Center(
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: secondary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.3),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
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
                              icon: const Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
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
                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    'อัพเดตล่าสุด ${widget.lastdate} | ${widget.lasttime}',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                  Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: smallSpacer - 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'ค่าอุณภูมิ ปริมาณความชื้น และความเข้มของแสง',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.width * .05),
                        linearbars("Temperature", "10", "°C"),
                        linearbars("Huimidity", "69", "%"),
                        linearbars("Light", "20", "Lux"),
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
                        const Text(
                          'ค่าปริมาณมลพิษ',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
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
                            const Text(
                              'กราฟค่าปริมาณมลพิษ',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<String>(
                              value: _selectedValue,
                              items: _dropdownValues.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
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

                        SizedBox(
                          width: size.width,
                          height: 60,
                          child: Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.purple,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'PM 1',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'PM 2.5',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'PM 10',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //Get Data for Chart
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('hourdata').doc(_selectedValue).collection(widget.id).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            List<QueryDocumentSnapshot> stations = snapshot.data!.docs;
                            Map<String, double> dataListpm01 = {};
                            Map<String, double> dataListpm25 = {};
                            Map<String, double> dataListpm10 = {};

                            Map<String, double> pm01data = {};
                            Map<String, double> pm25data = {};
                            Map<String, double> pm10data = {};

                            for (QueryDocumentSnapshot doc in stations) {
                              dataListpm01[doc.id] = double.parse(doc['pm01']);
                              dataListpm25[doc.id] = double.parse(doc['pm25']);
                              dataListpm10[doc.id] = double.parse(doc['pm10']);
                            }
                            for (int i = 0; i < 24; i++) {
                              String hour = i.toString().padLeft(2, '0');
                              if (dataListpm25.containsKey(hour)) {
                                pm25data[hour] = dataListpm25[hour]!;
                              } else {
                                pm25data[hour] = 0;
                              }
                            }

                            for (int i = 0; i < 24; i++) {
                              String hour = i.toString().padLeft(2, '0');
                              if (dataListpm01.containsKey(hour)) {
                                pm01data[hour] = dataListpm01[hour]!;
                              } else {
                                pm01data[hour] = 0;
                              }
                            }

                            for (int i = 0; i < 24; i++) {
                              String hour = i.toString().padLeft(2, '0');
                              if (dataListpm10.containsKey(hour)) {
                                pm10data[hour] = dataListpm10[hour]!;
                              } else {
                                pm10data[hour] = 0;
                              }
                            }

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
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    drawHorizontalLine: false,
                                    horizontalInterval: 1,
                                    verticalInterval: 1,
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
                                        reservedSize: 24,
                                        interval: 1,
                                        getTitlesWidget: bottomTitleWidgets,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        reservedSize: 24,
                                        getTitlesWidget: leftTitleWidgets,
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  minX: 0.0,
                                  maxX: 24.0,
                                  minY: 0.0,
                                  maxY: 100.0,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: pm25data.entries.map((entry) {
                                        return FlSpot(double.parse(entry.key), entry.value);
                                      }).toList(),
                                      isCurved: true,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.purple,
                                          Colors.purple,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: pm01data.entries.map((entry) {
                                        return FlSpot(double.parse(entry.key), entry.value);
                                      }).toList(),
                                      isCurved: true,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.red,
                                          Colors.red,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: pm10data.entries.map((entry) {
                                        return FlSpot(double.parse(entry.key), entry.value);
                                      }).toList(),
                                      isCurved: true,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.orange,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(
                          width: size.width,
                          height: 60,
                          child: Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'CO',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.pink,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'CO2',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'NO2',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //Get Data for Chart
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('hourdata').doc(_selectedValue).collection(widget.id).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final List<QueryDocumentSnapshot> stations = snapshot.data!.docs;
                            final Map<String, double> codata = {};
                            final Map<String, double> co2data = {};
                            final Map<String, double> no2data = {};

                            for (final QueryDocumentSnapshot doc in stations) {
                              codata[doc.id] = double.parse(doc['co']);
                              co2data[doc.id] = double.parse(doc['co2']);
                              no2data[doc.id] = double.parse(doc['no2']);
                            }

                            final List<FlSpot> cospots = [];
                            final List<FlSpot> co2spots = [];
                            final List<FlSpot> no2spots = [];

                            for (int i = 0; i < 24; i++) {
                              final String hour = i.toString().padLeft(2, '0');
                              final double covalue = codata[hour] ?? 0;
                              final double co2value = co2data[hour] ?? 0;
                              final double no2value = no2data[hour] ?? 0;
                              cospots.add(FlSpot(i.toDouble(), covalue));
                              co2spots.add(FlSpot(i.toDouble(), co2value));
                              no2spots.add(FlSpot(i.toDouble(), no2value));
                            }

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
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    drawHorizontalLine: false,
                                    horizontalInterval: 1,
                                    verticalInterval: 1,
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
                                        reservedSize: 24,
                                        interval: 1,
                                        getTitlesWidget: bottomTitleWidgets,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        reservedSize: 24,
                                        getTitlesWidget: leftTitleWidgets,
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  minX: 0.0,
                                  maxX: 24.0,
                                  minY: 0.0,
                                  maxY: 100.0,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: cospots,
                                      isCurved: false,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.blue,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: co2spots,
                                      isCurved: false,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.pink,
                                          Colors.pink,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: no2spots,
                                      isCurved: false,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Colors.green,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        //เกี่ยวกับสถานะไฟ
                        SizedBox(height: size.width * .05),
                        const Text(
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
                                    const Text(
                                      'สถานะการทำงานของดวงไฟ',
                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                    Row(
                                      children: const [
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
                                    const Text(
                                      'จำนวนโวลต์ : 12V',
                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                    const Text(
                                      'จำนวนวัตต์ : 4W',
                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                    const Text(
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

                        SizedBox(
                          width: size.width,
                          height: 60,
                          child: Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'โวลต์',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.pink,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'วัตต์',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        //Get Data for Chart
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('hourdata').doc(_selectedValue).collection(widget.id).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final List<QueryDocumentSnapshot> stations = snapshot.data!.docs;
                            final Map<String, double> voltdata = {};
                            final Map<String, double> wattdata = {};
                            final Map<String, double> ampsdata = {};

                            for (final QueryDocumentSnapshot doc in stations) {
                              voltdata[doc.id] = double.parse(doc['volt']);
                              wattdata[doc.id] = double.parse(doc['watt']);
                              ampsdata[doc.id] = double.parse(doc['amps']);
                            }

                            final List<FlSpot> voltspots = [];
                            final List<FlSpot> wattspots = [];
                            final List<FlSpot> ampsspots = [];

                            for (int i = 0; i < 24; i++) {
                              final String hour = i.toString().padLeft(2, '0');
                              final double voltvalue = voltdata[hour] ?? 0;
                              final double wattvalue = wattdata[hour] ?? 0;
                              final double ampsvalue = ampsdata[hour] ?? 0;

                              voltspots.add(FlSpot(i.toDouble(), voltvalue));
                              wattspots.add(FlSpot(i.toDouble(), wattvalue));
                              ampsspots.add(FlSpot(i.toDouble(), ampsvalue));
                            }

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
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    drawHorizontalLine: false,
                                    horizontalInterval: 1,
                                    verticalInterval: 1,
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
                                        reservedSize: 24,
                                        interval: 1,
                                        getTitlesWidget: bottomTitleWidgets,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        reservedSize: 24,
                                        getTitlesWidget: leftTitleVoltWattAmpsWidgets,
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  minX: 0.0,
                                  maxX: 24.0,
                                  minY: 0.0,
                                  maxY: 12.0,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: voltspots,
                                      isCurved: false,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.blue,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: wattspots,
                                      isCurved: false,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.pink,
                                          Colors.pink,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: ampsspots,
                                      isCurved: false,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.amber,
                                          Colors.amber,
                                        ],
                                      ),
                                      barWidth: 1.5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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

  SizedBox linearbars(String name, String value, String type) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
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
                  style: const TextStyle(color: Colors.black, fontSize: 12),
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
                    const SizedBox(width: 4),
                    Text(
                      type,
                      style: const TextStyle(
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
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
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
    case 20:
      text = '20';
      break;
    case 40:
      text = '40';
      break;
    case 60:
      text = '60';
      break;
    case 80:
      text = '80';
      break;
    case 100:
      text = '100';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}

Widget leftTitleVoltWattAmpsWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 10,
    color: black,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = '0';
      break;
    case 3:
      text = '3';
      break;
    case 6:
      text = '6';
      break;
    case 9:
      text = '9';
      break;
    case 12:
      text = '12';
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
      text = '04:00';
      break;
    case 8:
      text = '08:00';
      break;
    case 12:
      text = '12:00';
      break;
    case 16:
      text = '16:00';
      break;
    case 20:
      text = '20:00';
      break;
    case 23:
      text = '00:00';
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
