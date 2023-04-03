// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_airqualitymonitor/pages/addstation_page.dart';
import 'package:flutter_airqualitymonitor/pages/manage_page.dart';
import 'package:flutter_airqualitymonitor/pages/signin_page.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
  double _panelHeightOpen = 0;
  bool isfull = false;
  final double _panelHeightClosed = kToolbarHeight;
  late String role;

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

  Future<void> _getMarkers() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('allstation').get();
    final List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    for (var element in docs) {
      final lat = double.parse(element['lat']);
      final lng = double.parse(element['lng']);

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(element['name']),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: element['name'],
              anchor: Offset(0.5, 0.0),
              snippet: 'This is a custom info window',
              onTap: () {
                // handle info window tap
              },
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
          // the fab
          Positioned(
            right: 20.0,
            bottom: 180,
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
            bottom: 70,
            child: SizedBox(
              height: 100,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('allstation').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError && !snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<QueryDocumentSnapshot> stations = snapshot.data!.docs;

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: stations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> data = stations[index].data() as Map<String, dynamic>;

                      final String name = data['name'];
                      final lat = double.parse(data['lat']);
                      final lng = double.parse(data['lng']);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            panel: _panel(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel() {
    var size = MediaQuery.of(context).size;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: <Widget>[
          SizedBox(height: size.width * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: miniSpacer),
            ],
          ),
          SizedBox(height: size.width * 0.07),
          SizedBox(
            width: size.width * .9,
            height: size.width * 0.1,
            child: Text(
              "เกี่ยวกับฉัน",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: size.width * 0.02),
          Container(
            width: size.width * .9,
            height: size.width * .25,
            padding: EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                )
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.photoUrl),
                        radius: 30.0,
                      ),
                      SizedBox(width: size.width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.email),
                          Text("${widget.displayName} | ${widget.userRole}"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: size.width * 0.05),
          SizedBox(
            width: size.width * .9,
            height: size.width * .4,
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                if (role == "แอดมิน")
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddStation())),
                    child: _button(
                      "จัดการสถานี",
                      Icons.stay_primary_portrait_outlined,
                      Colors.white,
                    ),
                  ),
                _button(
                  "เปลื่ยนรหัสผ่าน",
                  Icons.password_outlined,
                  Colors.blue,
                ),
                GestureDetector(
                  onTap: () async {
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
                  child: _button("ออกจากระบบ", Icons.logout_outlined, Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String label, IconData icon, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * .435,
      height: 55,
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          SizedBox(width: miniSpacer),
          Icon(icon),
        ],
      ),
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
}
