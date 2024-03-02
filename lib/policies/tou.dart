import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/constant.dart';

class TermScreen extends StatefulWidget {
  const TermScreen({super.key});

  @override
  State<TermScreen> createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  String touText = '';

  getTou() async {
    var x =
        await FirebaseFirestore.instance.collection('policies').doc('1').get();
    setState(() {
      touText = x.data()!['tou'];
    });
  }

  @override
  void initState() {
    // getTou();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Term of Use')),
      body: SizedBox(
        height: height(context) * 1,
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset('assets/images/tou/1.png'),
            Image.asset('assets/images/tou/2.png'),
            Image.asset('assets/images/tou/3.png'),
            Image.asset('assets/images/tou/4.png'),
            Image.asset('assets/images/tou/5.png'),
            Image.asset('assets/images/tou/6.png'),
            Image.asset('assets/images/tou/7.png'),
            Image.asset('assets/images/tou/8.png'),
          ],
        ),
      ),
    );
  }
}
