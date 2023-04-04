// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_airqualitymonitor/widget/custom_card_member.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({
    super.key,
  });

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
                      Padding(
                        padding: EdgeInsets.only(left: padding, right: padding),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: spacer + 24),
                            SizedBox(height: spacer),
                            SizedBox(height: smallSpacer),
                            if (role) SizedBox(height: miniSpacer + miniSpacer),
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
                                        keys: allStationDocs.id,
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
