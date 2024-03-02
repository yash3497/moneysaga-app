import 'package:flutter/material.dart';
import 'package:magnus_app/views/home/cmd_message_screen.dart';
import 'package:magnus_app/views/home/home_screen.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';
import 'package:magnus_app/widget/custom_button_widget.dart';
import 'package:magnus_app/widget/my_bottom_bar.dart';

class paymentPage extends StatefulWidget {
  const paymentPage({super.key});

  @override
  State<paymentPage> createState() => _paymentPageState();
}

class _paymentPageState extends State<paymentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 20,
                child: Text(
                  "QR code",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white)),
                  child: Image.asset("assets/images/ashimage/paymentQR.png")),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 20,
                child: Text(
                  "Bank info",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.80,
                child: Column(children: [
                  Text(
                      "Bank Details for Deposit\nAccount name :\nMoneySaga Consultancy Services LLP\nAC/No : 04626340002271\nIFSC : YESB0000462\nBank Name : Yes Bank Limited\nBranch : Pimple Saudagar Pune")
                ]),
              ),
              SizedBox(
                height: 60,
              ),
              CustomButton(
                  textWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                  onTap: () {
                    //getOpt();

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MyBottomBar();
                    }));

                    // _razorpay.open(options);
                  }),
            ]),
          ),
          iconOverlay()
        ],
      )),
    );
  }
}
