import 'package:flutter/material.dart';
import 'package:magnus_app/utils/constant.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({required this.title, this.subtitle});
  String title;
  String? subtitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: black.withOpacity(0.1),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: TextStyle(color: yellow),
        ),
        Text(
          subtitle!,
          style: TextStyle(fontSize: 14, color: yellow),
        )
      ]),
    );
  }
}
