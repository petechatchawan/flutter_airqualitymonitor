// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_airqualitymonitor/pages/edit_page.dart';
import 'package:flutter_airqualitymonitor/pages/manage_page.dart';
import 'package:flutter_airqualitymonitor/pages/station.dart';
import 'package:flutter_airqualitymonitor/widget/custom_card_member.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_airqualitymonitor/pages/signin_page.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  final String displayName;
  final String photoUrl;
  final String userRole;
  const ProfilePage({
    Key? key,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.userRole,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late GoogleSignIn _googleSignIn;
  late User user;

  final Completer<GoogleMapController> _controller = Completer();
  final PageController _pageController = PageController(viewportFraction: 0.8);
  late CameraPosition _currentCameraPosition;
  final LatLng center = const LatLng(13.75566724308893, 100.50492146721047);
  final List<Marker> _markers = [];
  late double lat, lng;
  late String role;

  bool showMap = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn();
    _getMarkers();
    role = widget.userRole;
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        showMap = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((controller) {
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: getBody(),
    );
  }

  Stack getBody() {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        if (showMap) _buildMap(),
        IgnorePointer(
          child: AnimatedOpacity(
            curve: Curves.easeInCirc,
            duration: Duration(milliseconds: 1000),
            opacity: showMap ? 0 : 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Icon(
                  Icons.get_app,
                  size: 50,
                  color: secondary,
                ),
              ),
            ),
          ),
        ),

        //SHOW STATION
        Positioned(
          bottom: 40,
          child: Container(
            height: 200,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('allstation').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<QueryDocumentSnapshot> stations = snapshot.data!.docs;
                return PageView.builder(
                  controller: _pageController,
                  itemCount: stations.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> data = stations[index].data() as Map<String, dynamic>;
                    final String id = data['id'];
                    final String name = data['name'];
                    final String lastdate = data['lastdate'];
                    final String lasttime = data['lasttime'];
                    final lat = double.parse(data['lat']);
                    final lng = double.parse(data['lng']);

                    return Padding(
                      padding: EdgeInsets.only(bottom: padding, right: 8, left: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: miniSpacer),
                            Text(name, style: TextStyle(color: black, fontSize: 14.0)),
                            Text("อัพเดตล่าสุดวันที่ $lastdate เวลา $lasttime", style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            SizedBox(height: miniSpacer),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Station(
                                          id: id,
                                          name: name,
                                          lastdate: lastdate,
                                          lasttime: lasttime,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: textColor.withOpacity(.4),
                                      borderRadius: borderRadius,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "รายละเอียด",
                                        style: TextStyle(fontSize: 12, color: black),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditPage()),
                                    );
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: textColor.withOpacity(.4),
                                      borderRadius: borderRadius,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "แก้ไข",
                                        style: TextStyle(fontSize: 12, color: black),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
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

                                                allstationCols.doc(id).delete().then((value) => print("allstationCols $id Deleted")).catchError((error) => print("Failed to delete user: $error"));
                                                currentCols.doc(id).delete().then((value) => print("currentCols $id Deleted")).catchError((error) => print("Failed to delete user: $error"));

                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("ลบสถานี"),
                                                      content: Text("คุณลบสถานีสำเร็จแล้ว"),
                                                    );
                                                  },
                                                );
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
                                    width: 80,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: textColor.withOpacity(.4),
                                      borderRadius: borderRadius,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "ลบ",
                                        style: TextStyle(fontSize: 12, color: black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  onPageChanged: (index) async {
                    final Map<String, dynamic> data = stations[index].data() as Map<String, dynamic>;
                    final lat = double.parse(data['lat']);
                    final lng = double.parse(data['lng']);
                    final GoogleMapController controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: LatLng(lat, lng), zoom: 17, bearing: 45),
                    ));
                  },
                );
              },
            ),
          ),
        ),

        //GET CURRENT LOCATION
        Positioned(
          right: 20.0,
          bottom: 250.0,
          child: FloatingActionButton(
            onPressed: () {
              _getLocationPermission();
              _getCurrentLocation();
              _getMarkers();
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.gps_fixed,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        // TOP MENU
        Positioned(
          bottom: 0,
          right: 0,
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: size.width,
                height: isExpanded ? size.height * .35 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: smallSpacer),
                      Container(
                        width: size.width * .9,
                        height: size.width * 0.1,
                        color: Colors.transparent,
                        child: Text(
                          "เกี่ยวกับฉัน",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 75,
                            height: 75,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(widget.photoUrl),
                            ),
                          ),
                          SizedBox(width: miniSpacer),
                          Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: size.width * 0.05),
                                  Text(
                                    widget.email.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${widget.displayName} | ${widget.userRole}"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: miniSpacer),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Divider(
                          color: Colors.grey,
                          thickness: .8,
                        ),
                      ),
                      SizedBox(height: miniSpacer),
                      Container(
                        width: size.width,
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Wrap(
                          children: [
                            Container(
                              width: size.width * .425,
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('เปลื่ยนรหัสผ่าน'),
                              ),
                            ),
                            Container(
                              width: size.width * .425,
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('ลบบัญชี'),
                              ),
                            ),
                            Container(
                              width: size.width * .425,
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('ส่งออกรายงาน'),
                              ),
                            ),
                            Container(
                              width: size.width * .425,
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('เพิ่มสถานี'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: size.width,
                height: kToolbarHeight,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: smallSpacer - 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    if (!isExpanded)
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        blurRadius: 10,
                        offset: Offset(0, -10),
                      )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isExpanded) SizedBox(),
                    if (isExpanded)
                      TextButton(
                        onPressed: () async {
                          try {
                            await _googleSignIn.signOut().then(
                              (value) {
                                _googleSignIn.disconnect();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
                              },
                            );
                          } catch (e) {
                            print('Error signing out with Google: $e');
                          }
                        },
                        child: Center(
                          child: Text(
                            'ออกจากระบบ',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Icon(isExpanded ? Icons.close_outlined : Icons.menu_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set.from(_markers),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
    );
  }

  Future<void> _getCurrentLocation() async {
    _getLocationPermission();
    Position position = await Geolocator.getCurrentPosition();
    lat = position.latitude;
    lng = position.longitude;
    setState(
      () {
        _currentCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17.0,
          bearing: 45.0,
        );
      },
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
  }

  Future<void> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    final status = await Permission.location.request();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
    } else if (permission == LocationPermission.deniedForever) {
      // Handle permanently denied permission
    } else {
      // Permission granted
    }

    if (status == PermissionStatus.denied) {
      // ถ้าผู้ใช้ไม่อนุญาตให้เข้าถึงตำแหน่ง
      // ให้แสดงข้อความว่า "Location permission is required for this app to function"
    }
  }

  Future<void> _getMarkers() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('allstation').get();
    final List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    for (var element in docs) {
      final id = element['id'];
      final name = element['name'];
      final lat = double.parse(element['lat']);
      final lng = double.parse(element['lng']);
      final lastdate = element['lastdate'];
      final lasttime = element['lasttime'];

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: name,
              anchor: Offset(0.5, 0.0),
              snippet: 'กดเพื่อดูข้อมูล',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Station(
                      id: id,
                      name: name,
                      lastdate: lastdate,
                      lasttime: lasttime,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      });
    }
  }
}
