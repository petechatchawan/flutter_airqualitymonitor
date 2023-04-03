import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CustomButtonBox extends StatelessWidget {
  const CustomButtonBox({Key? key, required this.title, required this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 45.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(17.5),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
