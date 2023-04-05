// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_airqualitymonitor/pages/addstation_page.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_airqualitymonitor/widget/custom_card_member.dart';
import 'package:flutter_svg/svg.dart';

class ManagePage extends StatefulWidget {
  const ManagePage(
    this.userRole, {
    super.key,
  });

  final String userRole;

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
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

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('allstation').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> allStationSnapshot) {
        if (allStationSnapshot.hasError || !allStationSnapshot.hasData || allStationSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: size.width,
            height: size.height,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'กำลังโหลดข้อมูล ...',
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: smallSpacer),
                CircularProgressIndicator(
                  color: secondary,
                  backgroundColor: Colors.grey,
                ),
              ],
            ),
          );
        }

        // ดึงข้อมูลที่อยู่ใน allstation จาก snapshot ของ StreamBuilder
        final allStationDoc = allStationSnapshot.data!.docs;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('currentdata').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> currentDataSnapshot) {
            if (currentDataSnapshot.hasError || !currentDataSnapshot.hasData || currentDataSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: size.width,
                height: size.height,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'กำลังโหลดข้อมูล ...',
                      style: TextStyle(color: textColor),
                    ),
                    SizedBox(height: smallSpacer),
                    CircularProgressIndicator(
                      color: secondary,
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: size.width,
                            height: kToolbarHeight / 2,
                            color: Colors.white,
                          ),
                          Container(
                            width: size.width,
                            height: kToolbarHeight,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10),
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
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.menu_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: padding, right: padding),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 100),
                            if (widget.userRole == "แอดมิน")
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddStation()));
                                },
                                child: Container(
                                  width: size.width,
                                  height: size.height * .15,
                                  padding: EdgeInsets.all(4.0),
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
                                  child: Container(
                                    height: size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(.3),
                                      borderRadius: borderRadius,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/additem.svg", height: 24),
                                        SizedBox(width: 10),
                                        Text("เพิ่มสถานี", style: TextStyle(fontSize: 14, color: black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: miniSpacer + miniSpacer),
                            SingleChildScrollView(
                              child: Wrap(
                                children: List.generate(
                                  allStationDoc.length,
                                  (index) {
                                    // ดึงข้อมูลที่อยู่ใน allstation จาก snapshot ของ StreamBuilder
                                    final allStationDocs = allStationSnapshot.data!.docs[index];

                                    // ดึงข้อมูลที่อยู่ใน currentdata จาก snapshot ของ StreamBuilder
                                    final currentDataDocs = currentDataSnapshot.data!.docs[index];

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: padding),
                                      child: CustomCardMember(
                                        id: allStationDocs.id,
                                        name: allStationDocs['name'],
                                        lastdate: allStationDocs['lastdate'],
                                        lasttime: allStationDocs['lasttime'],
                                        pm01: int.parse(currentDataDocs['pm01'] ?? 0),
                                        pm25: int.parse(currentDataDocs['pm25'] ?? 0),
                                        pm10: int.parse(currentDataDocs['pm10'] ?? 0),
                                        co: int.parse(currentDataDocs['co'] ?? 0),
                                        co2: int.parse(currentDataDocs['co2'] ?? 0),
                                        no2: int.parse(currentDataDocs['no2'] ?? 0),
                                        temp: int.parse(currentDataDocs['temp'] ?? 0),
                                        humid: int.parse(currentDataDocs['humid'] ?? 0),
                                        light: int.parse(currentDataDocs['light'] ?? 0),
                                        userRole: widget.userRole,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
