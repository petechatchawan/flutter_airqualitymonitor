import 'package:flutter/material.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCardAdmin1 extends StatefulWidget {
  const CustomCardAdmin1({
    Key? key,
    required this.keys,
    required this.name,
    required this.lasttimeupdate,
    required this.lastdateupdate,
    required this.createdate,
  }) : super(key: key);

  final String keys;
  final String name;
  final String lasttimeupdate;
  final String lastdateupdate;
  final String createdate;

  @override
  State<CustomCardAdmin1> createState() => _CustomCardAdmin1State();
}

class _CustomCardAdmin1State extends State<CustomCardAdmin1> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              SizedBox(
                width: size.width,
                height: size.width * .4,
                child: ClipRRect(
                  borderRadius: borderRadius,
                ),
              ),
              Positioned(
                top: 8.0,
                right: 13.0,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("ลบสถานี"),
                          content: const Text("คุณยืนยันที่จะลบสถานีออกจากรายการสถานีหรือไม่?"),
                          actions: <Widget>[
                            // OK Button
                            TextButton(
                              child: const Text(
                                "ยืนยัน",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                // Perform action on OK press
                              },
                            ),
                            // Cancel Button
                            TextButton(
                              child: const Text(
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
                    width: 30.0,
                    height: 30.0,
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: SvgPicture.asset("assets/trash.svg", height: 24),
                  ),
                ),
              ),
              Positioned(
                top: 8.0,
                right: 55.0,
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: SvgPicture.asset("assets/edit.svg", height: 24),
                ),
              ),
              Positioned(
                top: 8.0,
                left: 8.0,
                child: Container(
                  width: 110.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(.75),
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Colors.grey.withOpacity(.25), // set the border color
                      width: 0.8, // set the border width
                    ),
                  ),
                  child: Text(
                    widget.keys,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.0,
                left: 123.0,
                child: Container(
                  width: 100.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(.75),
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Colors.grey.withOpacity(.25), // set the border color
                      width: 0.8, // set the border width
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/clock.svg", height: 18),
                      const SizedBox(width: 5),
                      Text(
                        widget.lasttimeupdate,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 8.0,
                left: 8.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        widget.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "วันที่อัพเดตล่าสุด  ${widget.lastdateupdate}",
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "เวลาที่อัพเดตล่าสุด ${widget.lasttimeupdate}",
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    SizedBox(height: miniSpacer),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
