import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magnus_app/services/cashfree_services.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/home/home_screen.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';
import 'package:magnus_app/views/screen/paymentPage.dart';
import 'package:magnus_app/widget/custom_button_widget.dart';
import 'package:magnus_app/widget/my_bottom_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  List premiumPlan = [
    {
      'title': '   Forex \n  Market \nEducation',
      'k': 'A',
      'db': 'pCourse1',
      'discPrice': '15000',
      'usd': '245'
    },
    {
      'title': 'Indian Stock \n     Market \n  Education',
      'db': 'pCourse2',
      'k': 'B',
      'discPrice': '15000',
      'usd': '245'
    },
    {
      'title': '  Combo \n  Course \nEducation',
      'k': 'A+B',
      'db': 'pCourse3',
      'discPrice': '25000',
      'usd': '405'
    }
  ];
  // final _razorpay = Razorpay();
  // var cfPaymentGatewayService = CFPaymentGatewayService();
  String plan = '';

  @override
  void initState() {
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    // cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  void verifyPayment(String orderId) async {
    users.setBoughtPack(premiumPlan[currentIndex], orderId);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyBottomBar()));
  }

  // void onError(CFErrorResponse errorResponse, String orderId) {
  //   Fluttertoast.showToast(
  //       msg: "Error: ${errorResponse.toString()}", timeInSecForIosWeb: 4);
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   users.setBoughtPack(premiumPlan[currentIndex], '');
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => MyBottomBar()));
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Do something when payment fails
  //   // FirebaseFirestore.instance.collection('users').doc(users.uid).delete();
  //   // FirebaseAuth.instance.signOut();
  //   SnackBar(content: Text("Payment Failed! Please Try Again After Sometime"));
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Do something when an external wallet was selected
  // }
  // var options;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyBottomBar()));
                        },
                        child: Container(
                            margin: EdgeInsets.all(10),
                            height: 40,
                            width: 40,
                            decoration: myFillBoxDecoration(0, yellow, 30),
                            child: Icon(
                              Icons.arrow_back,
                              color: black,
                            )),
                      ),
                    ),
                    Image.asset(
                      'assets/images/ppp.png',
                      height: 200,
                      width: 200,
                    ),
                    addVerticalSpace(height(context) * 0.09),
                    Text(
                      'You only get 3 videos for sample for free',
                      style: bodyText12Small(color: white),
                    ),
                    Text(
                      'Subscribe and Join Our Family',
                      style: bodyText16w700(color: yellow),
                    ),
                    addVerticalSpace(height(context) * 0.05),
                    Container(
                      padding: EdgeInsets.only(left: width(context) * 0.02),
                      height: height(context) * 0.3,
                      child: ListView.builder(
                          itemCount: premiumPlan.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: () {
                                currentIndex = index;

                                setState(() {
                                  plan = premiumPlan[currentIndex]['title'];
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: width(context) * 0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(10),
                                        border: currentIndex == index
                                            ? Border.all(
                                                color: yellow, width: 2)
                                            : Border()),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            premiumPlan[index]['title'],
                                            style: bodyText12w600(
                                                color: currentIndex == index
                                                    ? yellow
                                                    : white),
                                          ),
                                        ),
                                        Text(
                                          '(${premiumPlan[index]['k']})',
                                          style: TextStyle(
                                              color: currentIndex == index
                                                  ? yellow
                                                  : white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Rs. ${premiumPlan[index]['discPrice']}\n+GST',
                                                style: bodyText12w600(
                                                    color: currentIndex == index
                                                        ? yellow
                                                        : white),
                                              ),
                                              // SizedBox(),
                                              Text(
                                                '(USD ${premiumPlan[index]['usd']})',
                                                style: bodyText12w600(
                                                    color: currentIndex == index
                                                        ? yellow
                                                        : white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  addHorizontalySpace(10)
                                ],
                              ),
                            );
                          }),
                    ),
                    Text(''),
                    addVerticalSpace(height(context) * 0.05),
                    CustomButton(
                        textWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Proceed to pay',
                              style: TextStyle(
                                  color: black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: black,
                              size: 20,
                            )
                          ],
                        ),
                        onTap: () {
                          //getOpt();

                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return paymentPage();
                          }));

                          // _razorpay.open(options);
                        }),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isPremium = true;
                            // log(isPremium.toString());
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyBottomBar()));
                          });
                        },
                        child: Text(
                          'Skip for now',
                          style: bodyText14w600(color: yellow),
                        ))
                  ],
                ),
              ),
              iconOverlay()
            ],
          ),
        ),
      ),
    );
  }

  int gstAmt(int amt) {
    int gsta = 0;
    gsta = amt + ((12 * amt) / 100).ceil();
    return gsta;
  }

  void getOpt() async {
    int usdPrice = int.parse(premiumPlan[currentIndex]['usd']);
    int inrPrice = int.parse(premiumPlan[currentIndex]['discPrice']);
    var x = await FirebaseFirestore.instance
        .collection('users')
        .doc(users.uid)
        .get();
    print(x.data());
    // users.setCountry(x.data());

    plan = premiumPlan[currentIndex]['title'];
    print(users.country);
    // _doCashFreePayment(
    //     amount: users.country.toLowerCase() == 'india' ||
    //             users.country == ' ' ||
    //             users.country == ''
    //         ? gstAmt(inrPrice)
    //         : gstAmt(usdPrice),
    //     currency: users.country.toLowerCase() == 'india' || users.country == ' '
    //         ? 'INR'
    //         : 'USD');
    // options = {
    //   'key': 'rzp_test_E1MEHejU50nJcP',
    //   'amount': users.country == 'India' ? gstAmt(inrPrice) : gstAmt(usdPrice),
    //   'currency': users.country == 'India' ? 'INR' : 'USD',
    //   'prefill': {'contact': users.mobNum, 'email': users.email},
    //   'name': 'Plan : ${plan}',
    //   'description': 'premium',
    //   'prefill': {'contact': users.mobNum, 'email': users.email},
    // };
  }

//   void _doCashFreePayment(
//       {required int amount, required String currency}) async {
//     var rng = Random();
//     String l = rng.nextInt(100000).toString();
//     try {
//       print('$amount ------ $currency');
//       var orderData = await CashFreePaymentIntegration.generateOrder(
//           orderAmount: amount.toDouble(),
//           orderId: l,
//           currency: currency,
//           plan: premiumPlan[currentIndex]);
//       var session = CFSessionBuilder()
//           .setEnvironment(CFEnvironment.SANDBOX)
//           .setOrderId(l)
//           .setPaymentSessionId(orderData['payment_session_id'])
//           .build();
//       List<CFPaymentModes> components = <CFPaymentModes>[];
//       components.add(CFPaymentModes.UPI);
//       components.add(CFPaymentModes.CARD);
//       components.add(CFPaymentModes.WALLET);
//       var paymentComponent =
//           CFPaymentComponentBuilder().setComponents(components).build();
//       var theme = CFThemeBuilder()
//           .setNavigationBarBackgroundColorColor("#FEAD1D")
//           .setNavigationBarTextColor("#000000")
//           .setPrimaryFont("Menlo")
//           .setSecondaryFont("Futura")
//           .build();
//       var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
//           .setSession(session)
//           .setPaymentComponent(paymentComponent)
//           .setTheme(theme)
//           .build();

//       cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
//     } on CFException catch (e) {
//       print(e.message);
//     }
//   }
}
