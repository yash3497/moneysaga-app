import 'package:flutter/material.dart';
import 'package:magnus_app/utils/constant.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.textWidget, required this.onTap});
  Widget textWidget;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: height(context) * 0.07,
          width: width(context) * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: yellow,
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.blue.shade400,
            //       spreadRadius: 1,
            //       offset: Offset(0, 4))
            // ]
          ),
          child: textWidget),
    );
  }
}
