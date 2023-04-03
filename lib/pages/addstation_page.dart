// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AddStation extends StatefulWidget {
  const AddStation({super.key});

  @override
  State<AddStation> createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const _chars = '1234567890';
  final Random _rnd = Random();

  int textLenght = 0;

  String textlen = "";
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _currentCameraPosition;

  Future<void> _getCurrentLocation() async {
    _checkPermission();
    Position position = await Geolocator.getCurrentPosition();
    if (position != null) {
      double lat = position.latitude;
      double lng = position.longitude;
      setState(
        () {
          latController.text = lat.toString();
          lngController.text = lng.toString();
          _currentCameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 17.0,
          );
        },
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
    }
  }

  static CameraPosition _bangkok = CameraPosition(
    target: LatLng(13.751010202728118, 100.50878817394292),
    zoom: 15,
  );

  Future<void> _checkPermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.denied) {
      // ถ้าผู้ใช้ไม่อนุญาตให้เข้าถึงตำแหน่ง
      // ให้แสดงข้อความว่า "Location permission is required for this app to function"
    }
  }

  @override
  void dispose() {
    _controller.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
    nameController.dispose();
    latController.dispose();
    lngController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            Center(
              child: Container(
                width: size.width * .9,
                height: size.width,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [
                    Card(
                      elevation: 8,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: _bangkok,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () async {
                          _getCurrentLocation();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.only(right: miniSpacer, left: miniSpacer),
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
                          child: Icon(
                            Icons.gps_fixed,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Container(
                width: size.width * .8,
                height: size.width * .85,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: smallSpacer),
                    Container(
                      height: 50,
                      width: size.width,
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(.2),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            child: SvgPicture.asset('assets/bulletin-board.svg', height: 24),
                          ),
                          SizedBox(width: miniSpacer + 6),
                          Flexible(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  textLenght = nameController.text.length;
                                  if (textLenght > 20) {
                                    textlen = "จำกัด \n20 ตัว";
                                  } else {
                                    textlen = "";
                                  }
                                });
                              },
                              keyboardType: TextInputType.name,
                              obscureText: false,
                              maxLines: 1,
                              controller: nameController,
                              cursorColor: black,
                              maxLength: 20,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "ชื่อของสถานี",
                                labelStyle: TextStyle(
                                  color: black.withOpacity(0.7),
                                  fontSize: 15.0,
                                  height: .6,
                                ),
                                // add the maxLength property here
                                counterText: '', // remove the character count display
                              ),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              textlen,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: smallSpacer - miniSpacer),
                    Container(
                      height: 50,
                      width: size.width,
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(.2),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            child: SvgPicture.asset("assets/globe.svg", height: 20),
                          ),
                          SizedBox(width: miniSpacer + 6),
                          Flexible(
                            child: TextFormField(
                              onTap: () {},
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              controller: latController,
                              enabled: false,
                              maxLines: 1,
                              cursorColor: black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "ละติจูด",
                                labelStyle: TextStyle(
                                  color: black.withOpacity(0.7),
                                  fontSize: 15.0,
                                  height: .6,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: smallSpacer - miniSpacer),
                    Container(
                      height: 50,
                      width: size.width,
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(.2),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            child: SvgPicture.asset("assets/globe2.svg", height: 20),
                          ),
                          SizedBox(width: miniSpacer + 6),
                          Flexible(
                            child: TextFormField(
                              onTap: () {},
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              controller: lngController,
                              maxLines: 1,
                              enabled: false,
                              cursorColor: black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "ลองจิจูด",
                                labelStyle: TextStyle(
                                  color: black.withOpacity(0.7),
                                  fontSize: 15.0,
                                  height: .6,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: smallSpacer),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          if (nameController.text.isEmpty || latController.text.isEmpty || lngController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('บันทึกไม่สำเร็จ'),
                                content: Text('กรุณาใส่ข้อมูลให้ถูกต้อง'),
                                elevation: 24.0,
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('ตกลง'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            addstation();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 50,
                                width: size.width * .3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade800,
                                      Colors.blue.shade600,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: borderRadius,
                                  boxShadow: [
                                    BoxShadow(
                                      color: black.withOpacity(0.1),
                                      blurRadius: 10.0,
                                      offset: Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: Text(
                                  "ย้อนกลับ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: miniSpacer),
                            GestureDetector(
                              onTap: () {
                                if (nameController.text.isEmpty || latController.text.isEmpty || lngController.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('บันทึกไม่สำเร็จ'),
                                      content: Text('กรุณาใส่ข้อมูลให้ถูกต้อง'),
                                      elevation: 24.0,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('ตกลง'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  addstation();
                                }
                              },
                              child: Container(
                                height: 50,
                                width: size.width * .3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade800,
                                      Colors.green.shade600,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: borderRadius,
                                  boxShadow: [
                                    BoxShadow(
                                      color: black.withOpacity(0.1),
                                      blurRadius: 10.0,
                                      offset: Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: Text(
                                  "เพิ่มสถานี",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addstation() async {
    String rand = '';
    rand = getRandomString(10);
    CollectionReference places = firestore.collection('allstation');
    CollectionReference initValue = firestore.collection('currentdata');
    await initValue.doc(rand).set({
      'pm01': "0",
      'pm25': "0",
      'pm10': "0",
      'co': "0",
      'co2': "0",
      'no2': "0",
      'temp': "0",
      'humid': "0",
      'light': "0",
    });
    await places.doc(rand).set({
      'id': rand,
      'name': nameController.text.trim(),
      'lat': latController.text,
      'lng': lngController.text,
      'lastdate': formattedDate,
      'lasttime': formattedTime = DateFormat('HH:mm').format(now),
    }).then(
      (value) {
        nameController.clear();
        latController.clear();
        lngController.clear();
        textlen = "";
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('บันทึกสำเร็จแล้ว'),
            content: Text('สร้างสถานีใหม่แล้ว คีย์ของคุณคือ $rand'),
            elevation: 24.0,
            actions: [
              TextButton(
                onPressed: () {
                  final value = ClipboardData(text: rand);
                  Clipboard.setData(value).then((value) => Navigator.of(context).pop());
                },
                child: Text('คัดลอก'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ตกลง'),
              ),
            ],
          ),
        );
      },
    );
  }
}
