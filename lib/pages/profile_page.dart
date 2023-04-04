// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_airqualitymonitor/pages/manage_page.dart';
import 'package:flutter_airqualitymonitor/pages/showstation.dart';
import 'package:flutter_airqualitymonitor/pages/station.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:flutter_airqualitymonitor/pages/addstation_page.dart';
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
  late CameraPosition _currentCameraPosition;
  late double lat;
  late double lng;
  final LatLng center = const LatLng(13.75566724308893, 100.50492146721047);
  late String role;

  bool isExpanded = false;

  bool showMap = false;
  final List<Marker> _markers = [];
  final PageController _pageController = PageController(viewportFraction: 0.8);

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
              color: Colors.blue,
              child: Center(
                child: Icon(
                  Icons.get_app,
                  size: 60,
                  color: Colors.white.withAlpha(100),
                ),
              ),
            ),
          ),
        ),

        // TOP MENU
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: size.width,
                  height: isExpanded ? size.height * .35 : kToolbarHeight * .5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: kToolbarHeight),
                        Container(
                          width: size.width * .9,
                          height: size.width * 0.1,
                          color: Colors.transparent,
                          child: Text(
                            "เกี่ยวกับฉัน",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.photoUrl),
                          ),
                        ),
                        SizedBox(height: miniSpacer),
                        Container(
                          width: size.width * .9,
                          color: Colors.transparent,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                        SizedBox(height: miniSpacer),
                        Container(
                          width: size.width * .9,
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text('เปลื่ยนรหัสผ่าน'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePage()));
                                },
                                child: Text('จัดการสถานี'),
                              ),
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
                                child: Text(
                                  'ออกจากระบบ',
                                  style: TextStyle(color: Colors.red),
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
                      Text(
                        isExpanded ? '' : 'การตรวจสอบคุณภาพอากาศ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(isExpanded ? Icons.close_outlined : Icons.menu_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: 20.0,
          bottom: 180.0,
          child: FloatingActionButton(
            onPressed: () {
              _getLocationPermission();
              _getCurrentLocation();
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.gps_fixed,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          child: Container(
            height: 150,
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

                    final String name = data['name'];
                    final lat = double.parse(data['lat']);
                    final lng = double.parse(data['lng']);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Lat: $lat',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Lng: $lng',
                              style: TextStyle(fontSize: 12),
                            ),
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
                      CameraPosition(target: LatLng(lat, lng), zoom: 16, bearing: 45),
                    ));
                  },
                );
              },
            ),
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
