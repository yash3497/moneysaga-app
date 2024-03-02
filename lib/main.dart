import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magnus_app/views/home/home_screen.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';
import 'package:magnus_app/views/screen/paymentPage.dart';
import 'package:magnus_app/views/start/splash_screen.dart';
import 'package:magnus_app/widget/my_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneySaga Consultancy',
      // darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,

      theme: ThemeData(
          primarySwatch: Colors.grey,
          brightness: Brightness.dark,
          //
          //scaffoldBackgroundColor: const Color.fromRGBO(50, 50, 50, 0.8),
          fontFamily: GoogleFonts.poppins().fontFamily),
      home: Stack(
        children: [
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot<User?> user) {
                if (user.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                } else if (user.hasData && user.data!.emailVerified == true) {
                  return MyBottomBar();
                } else {
                  return SplashScreen();
                  //return paymentPage();
                }
              }),
        ],
      ),
    );
  }
}
