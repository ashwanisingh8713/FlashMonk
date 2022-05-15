
import 'package:flutter/material.dart';
import 'package:monk_mvp/authenticatoin/signin_signup.dart';
import 'package:package_info_plus/package_info_plus.dart';
late SplashScreenState pageState;

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    pageState = SplashScreenState();
    return pageState;
  }
}

class SplashScreenState extends State<SplashScreen> {
  String appName = "";

  @override
  void initState() {
    super.initState();
    getAppInfo();

  }

  void getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpScreen(),
            ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(appName),
        ),
      ),
    );
  }
}