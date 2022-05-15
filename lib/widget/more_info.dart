import 'dart:ui';

import 'package:flutter/material.dart';
import '../utils/constanst.dart';

Widget moreInfo({
  required String wind,
  required String humidity,
  required String feelsLike,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        margin: EdgeInsets.only(bottom:5, left: 5, right: 5),
        width: 600,
        height: 600 / 11,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 1.9)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Wind", style: kMoreInfoFont),
                Text("Humidity", style: kMoreInfoFont),
                Text("FeelsLike", style: kMoreInfoFont),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(wind, style: kMoreInfoFont),
                Text(humidity, style: kMoreInfoFont),
                Text(feelsLike, style: kMoreInfoFont),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
