import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_airqualitymonitor/pages/profile_page.dart';
import 'package:flutter_airqualitymonitor/pages/signin_page.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;
  bool isSignedIn = false;

  Future<void> checkSignIn(BuildContext context) async {
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      print("ผู้ใช้ลงชื่อเข้าใช้แล้ว");
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final DocumentSnapshot doc = await _db.collection('users').doc(account?.id).get();
      final data = doc.data() as Map<String, dynamic>;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            email: account!.email,
            displayName: account.displayName!,
            photoUrl: account.photoUrl!,
            userRole: data['role'],
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
      print("ผู้ใช้ไม่ได้ลงชื่อเข้าใช้");
    }
  }

  @override
  void initState() {
    super.initState();
    print("object");
    Timer(const Duration(seconds: 3), () => checkSignIn(context));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('กำลังโหลดข้อมูลไปยัง CheckAuth ...'),
            SizedBox(height: smallSpacer),
            CircularProgressIndicator(
              color: secondary,
              backgroundColor: Colors.blue.shade100,
            ),
          ],
        ),
      ),
    );
  }
}
