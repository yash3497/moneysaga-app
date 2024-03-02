import 'package:flutter/material.dart';

Widget iconOverlay() {
  return Positioned(
      top: 20,
      right: 10,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Image.asset("assets/images/LOG.png"),
      ));
}
