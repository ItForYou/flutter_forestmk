

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterforestmk/main.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(//이미지 꾸미기
              fit:BoxFit.fitHeight,
              //image:  AssetImage("images/wing_mb_noimg2.png"),
              image: AssetImage("images/splash.png")
          )
      ),
    );
  }
}