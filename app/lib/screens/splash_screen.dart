import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}
class _MySplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), ()=>Navigator.pushNamed(context, '/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
      child: InkWell(
        onTap: () {Navigator.pushNamed(context, '/login');},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset('assets/img/logo.png',
              width: 110.0, height: 110.0),
        ),
      ),
    );
  }
}
