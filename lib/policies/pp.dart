import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magnus_app/utils/constant.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
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
    // final pdfController = PdfController(
    //   document: PdfDocument.openAsset('assets/pol/pol.pdf'),
    // );

    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policies')),
      body: SizedBox(
        height: height(context) * 1,
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset('assets/images/pol/1.png'),
            Image.asset('assets/images/pol/2.png'),
            Image.asset('assets/images/pol/3.png'),
            Image.asset('assets/images/pol/4.png'),
            Image.asset('assets/images/pol/5.png'),
            Image.asset('assets/images/pol/6.png'),
          ],
        ),
      ),
    );
  }
}
