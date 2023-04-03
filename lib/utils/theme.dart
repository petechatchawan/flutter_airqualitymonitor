// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const white = Color(0xFFFFFFFF);
const black = Color(0xFF000000);
const primary = Color(0xFFF5F5F7);
const secondary = Color(0xFF0d1117);
const background = Color(0xFFF5F5F7);
const buttonColor = Color(0xFF161B22);

const textColor = Color(0xFFc9d1d9);

const onecolor = Color(0xFF92A3FD);
const twocolor = Color(0xFF9DCEFF);
const thirdColor = Color(0xFFC58BF2);
const fourthColor = Color(0xFFEEA4CE);

double padding = 24.0;
double spacer = 50.0;
double smallSpacer = 30.0;
double miniSpacer = 10.0;

BorderRadius borderRadius = BorderRadius.circular(16);

bool role = false;
bool eye = false;

DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy-MM-dd').format(now);
late String formattedTime;

bool isOpenMenu = false;
int currentIndex = 0;
