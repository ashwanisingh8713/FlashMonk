import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//
import '../utils/constanst.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


Widget currentWeather({
  required VoidCallback onPressed,
  required String? temp,
  required String? location,
  required String? country,
  required String? status,
  required User? user,
}) {
  return Container(
    width: double.infinity,
    child: Container(
      margin: EdgeInsets.only(top: 40,left: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${capitalize(user!.displayName.toString())} is in $location, $country", style: kTitleFont),
                  SizedBox(width: 5,),
                ],
              ),
              Text("${temp}°", style: kTempFont),
            ],
          ),
          Expanded(child: Container()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: 400 / 13,
            height: 500 / 5,
            child: RotatedBox(
              quarterTurns: -1,
              child: Center(
                child: Text(
                  status!,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
