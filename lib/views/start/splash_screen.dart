import 'dart:async';

import 'package:flutter/material.dart';

import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';

import 'onboarding_scrceen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getCountries();
    Timer(
        Duration(seconds: 2),
        (() => Navigator.push(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()))));
    super.initState();
  }

  getCountries() {
    listCountries.clear();
    for (var element in countriesList) {
      listCountries.add(element.name);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: height(context) * 0.15),
                  child: Center(child: Image.asset('assets/images/LOG.png')),
                ),
                Positioned(
                  bottom: height(context) * 0.35,
                  // left: 50,
                  child: Text(
                    'MoneySaga Consultancy\n Services LLP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(5.0, 4.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                        color: yellow),
                  ),
                ),
                Positioned(
                  bottom: height(context) * 0.31,
                  // left: 55,
                  child: Text(
                    'Your Story of Financial Freedom',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(5.0, 4.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                        color: white),
                  ),
                )
              ],
            ),
          ),
          iconOverlay(),
        ],
      ),
    );
  }
}
