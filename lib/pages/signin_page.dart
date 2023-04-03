// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_airqualitymonitor/pages/profile_page.dart';
import 'package:flutter_airqualitymonitor/utils/theme.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Sign in with Google
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      // Get user information
      final String email = account!.email;
      final String? displayName = account.displayName;
      final String? photoUrl = account.photoUrl;

      // Check if user already exists in Firestore
      final DocumentSnapshot docSnapshot = await _db.collection('users').doc(account.id).get();
      if (!docSnapshot.exists) {
        // If user does not exist, store user information in Firestore
        await _db.collection('users').doc(account.id).set({
          'email': email,
          'displayName': displayName,
          'photoUrl': photoUrl,
          'role': 'สมาชิก',
        });
      }

      // Retrieve user's role from Firestore
      final DocumentSnapshot doc = await _db.collection('users').doc(account.id).get();
      final data = doc.data() as Map<String, dynamic>;
      final userRole = data['role'];

      // Navigate to ProfilePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            email: email,
            displayName: displayName!,
            photoUrl: photoUrl!,
            userRole: userRole,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error signing in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Container getBody() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: signInWithGoogle,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: _isLoading ? 55 : 250,
          height: 55,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.3),
                blurRadius: 5,
              )
            ],
          ),
          child: _isLoading
              ? Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.transparent,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/google.svg"),
                    SizedBox(width: 8),
                    Text('ลงชื่อเข้าใช้ด้วย Google'),
                  ],
                ),
        ),
      ),
    );
  }
}
