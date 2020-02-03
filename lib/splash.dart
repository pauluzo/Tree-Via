 import 'dart:async';

import 'package:treevia_app/home.dart';
import 'package:flutter/material.dart';
 
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
  
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Text(
          'Tree-Via',
          style: TextStyle(
            fontSize: 80.0, fontFamily: "Satisfy", color: Colors.white,
          ),
        ),
      ),
    );
  }
} 