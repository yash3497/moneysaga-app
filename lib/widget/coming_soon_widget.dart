import 'package:flutter/material.dart';

import '../utils/constant.dart';

class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      padding: EdgeInsets.all(8),
      height: height(context) * 0.37,
      width: width(context) * 1,
      decoration: myFillBoxDecoration(0, Colors.white.withOpacity(0.1), 15),
      child: Center(
        child: Text(
          "Coming Soon",
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      ),
    );
  }
}
