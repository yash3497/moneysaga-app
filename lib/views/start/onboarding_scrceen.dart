import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';
import 'package:magnus_app/views/start/create_profile_screen.dart';
import 'package:magnus_app/views/start/sign_up_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../preregistration/prereg_screen.dart';
import 'log_in_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = PageController();

  bool isPublished = false;

  @override
  void initState() {
    getAppPublishStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.1),
      body: Stack(
        children: [
          Container(
            height: height,
            child: Stack(
              children: [
                PageView(
                  controller: controller,
                  children: [
                    buildPage(
                        Logo:
                            'Get an overview of how you are performing and motivate yourself to achieve even more.',
                        title: "Welcome to MoneySaga Consultancy Services",
                        context: context),
                    buildPage(
                        Logo:
                            'Get an overview of how you are performing and motivate yourself to achieve even more.',
                        title: "Learn at Your Own Comfort",
                        context: context),
                    true ? SignUpScreen() : PreRegScreen()
                  ],
                  onPageChanged: (index) {
                    if (index == 2) {
                      true
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()))
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreRegScreen()));
                    }
                  },
                ),
                Positioned(
                  left: 30,
                  bottom: 50,
                  child: Container(
                    height: height * 0.07,
                    color: Colors.transparent,
                    child: Center(
                      child: SmoothPageIndicator(
                        count: 3,
                        controller: controller,
                        effect: ExpandingDotsEffect(
                            spacing: width * 0.015,
                            dotWidth: width * 0.02,
                            dotHeight: height * 0.007,
                            dotColor: Colors.white.withOpacity(0.5),
                            activeDotColor: white), // WormEffect
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // left: 210,
                  right: 40,
                  bottom: 50,
                  child: InkWell(
                    onTap: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                      isPosition = true;
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: myFillBoxDecoration(0, white, 30),
                        child: Icon(
                          Icons.arrow_forward,
                          color: black,
                        )),
                  ),
                ),
                isPublished
                    ? Positioned(
                        right: 10,
                        top: 40,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: ((context) => LogInScreen())));
                            },
                            child: Text('Skip',
                                style: bodyText14w600(color: black))))
                    : const SizedBox(),
              ],
            ),
          ),
          iconOverlay()
        ],
      ),
    );
  }

  void getAppPublishStatus() async {
    var x = await FirebaseFirestore.instance
        .collection('preregistration')
        .doc('status')
        .get();

    isPublished = x.data()!['isPublished'];
  }
}

Widget buildPage({
  required String title,
  required String Logo,
  required BuildContext context,
}) {
  return Container(
    child: Stack(
      children: [
        Positioned(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
            color: ligyellow,
          ),
        ),
        Positioned(
          left: 20,
          right: 40,
          top: height(context) * 0.62,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: bodyText24W600(color: yellow)),
              // SizedBox(
              //   height: 20,
              // ),
              // Text(
              //   Logo,
              //   style: TextStyle(
              //       fontSize: 15, color: Colors.white.withOpacity(0.7)),
              // ),
            ],
          ),
        ),
        // Positioned(
        //   left: 20,
        //   right: 20,
        //   bottom: height(context) * 0.15,
        //   child:
        // ),
        Positioned(
          top: height(context) * 0.06,
          child: Image.asset(
            'assets/images/onbord2.png',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: height(context) * 0.09,
          left: -8,
          child: Image.asset(
            'assets/images/onbord.png',
            fit: BoxFit.fill,
          ),
        ),
      ],
    ),
  );
}
