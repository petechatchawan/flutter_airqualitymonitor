// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TotalResult {
  int total;
  Color progressColor;
  Color backgroundColor;

  TotalResult(this.total, this.progressColor, this.backgroundColor);
}

TotalResult getTotal(int value, String nametype) {
  int total;
  Color progressColor;
  Color backgroundColor;
  if (nametype == "PM 1") {
    if (value > 0 && value <= 25) {
      total = 25;
      progressColor = Colors.blue;
      backgroundColor = Colors.blue.shade100;
    } else if (value > 25 && value <= 37) {
      total = 37;
      progressColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (value > 37 && value <= 50) {
      total = 50;
      progressColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else if (value > 50 && value <= 90) {
      total = 90;
      progressColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (value > 90) {
      total = 400;
      progressColor = Colors.red;
      backgroundColor = Colors.red.shade100;
    } else {
      total = 0;
      progressColor = Colors.grey;
      backgroundColor = Colors.grey.shade100;
    }
  } else if (nametype == "PM 2.5") {
    if (value > 0 && value <= 25) {
      total = 25;
      progressColor = Colors.blue;
      backgroundColor = Colors.blue.shade100;
    } else if (value > 25 && value <= 37) {
      total = 37;
      progressColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (value > 37 && value <= 50) {
      total = 50;
      progressColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else if (value > 50 && value <= 90) {
      total = 90;
      progressColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (value > 90) {
      total = 400;
      progressColor = Colors.red;
      backgroundColor = Colors.red.shade100;
    } else {
      total = 0;
      progressColor = Colors.grey;
      backgroundColor = Colors.grey.shade100;
    }
  } else if (nametype == "PM 10") {
    if (value > 0 && value <= 50) {
      total = 50;
      progressColor = Colors.blue;
      backgroundColor = Colors.blue.shade100;
    } else if (value > 50 && value <= 80) {
      total = 80;
      progressColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (value > 80 && value <= 120) {
      total = 120;
      progressColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else if (value > 120 && value <= 180) {
      total = 180;
      progressColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (value > 180) {
      total = 400;
      progressColor = Colors.red;
      backgroundColor = Colors.red.shade100;
    } else {
      total = 0;
      progressColor = Colors.grey;
      backgroundColor = Colors.grey.shade100;
    }
  } else if (nametype == "CO") {
    if (value > 0 && value <= 4.4) {
      total = 5;
      progressColor = Colors.blue;
      backgroundColor = Colors.blue.shade100;
    } else if (value > 4.5 && value <= 6.4) {
      total = 7;
      progressColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (value > 6.5 && value <= 9) {
      total = 9;
      progressColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else if (value > 9.1 && value <= 30) {
      total = 180;
      progressColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (value > 30) {
      total = 100;
      progressColor = Colors.red;
      backgroundColor = Colors.red.shade100;
    } else {
      total = 0;
      progressColor = Colors.grey;
      backgroundColor = Colors.grey.shade100;
    }
  } else if (nametype == "CO2") {
    if (value > 0 && value <= 4.4) {
      total = 5;
      progressColor = Colors.blue;
      backgroundColor = Colors.blue.shade100;
    } else if (value > 4.5 && value <= 6.4) {
      total = 7;
      progressColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (value > 6.5 && value <= 9) {
      total = 9;
      progressColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else if (value > 9.1 && value <= 30) {
      total = 180;
      progressColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (value > 30) {
      total = 100;
      progressColor = Colors.red;
      backgroundColor = Colors.red.shade100;
    } else {
      total = 0;
      progressColor = Colors.grey;
      backgroundColor = Colors.grey.shade100;
    }
  } else if (nametype == "NO2") {
    if (value > 0 && value <= 60) {
      total = 60;
      progressColor = Colors.blue;
      backgroundColor = Colors.blue.shade100;
    } else if (value > 60 && value <= 106) {
      total = 106;
      progressColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (value > 107 && value <= 170) {
      total = 170;
      progressColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else if (value > 171 && value <= 340) {
      total = 340;
      progressColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (value > 341) {
      total = 500;
      progressColor = Colors.red;
      backgroundColor = Colors.red.shade100;
    } else {
      total = 0;
      progressColor = Colors.grey;
      backgroundColor = Colors.grey.shade100;
    }
  } else {
    total = 0;
    progressColor = Colors.grey;
    backgroundColor = Colors.grey.shade100;
  }

  return TotalResult(total, progressColor, backgroundColor);
}
