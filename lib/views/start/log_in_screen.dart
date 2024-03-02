import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magnus_app/services/deviceinfo/getDeviceInfo.dart';
import 'package:magnus_app/views/home/home_screen.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';
import 'package:magnus_app/views/start/forgot_password.dart';
import 'package:magnus_app/views/start/sign_up_screen.dart';
import 'package:magnus_app/widget/custom_textformfield.dart';
import 'package:magnus_app/widget/my_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/firebase_authen.dart';
import '../../utils/constant.dart';
import '../../widget/custom_button_widget.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();

  bool _passVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                addVerticalSpace(height(context) * 0.04),
                Center(
                  child: Container(
                    height: height(context) * 0.3,
                    padding: EdgeInsets.only(left: 20),
                    child: Image.asset('assets/images/img1.png'),
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                Text(
                  'Hey there,',
                  style: TextStyle(
                    fontSize: 16,
                    color: white.withOpacity(0.9),
                  ),
                ),
                Text('Welcome Back', style: bodyText20w700(color: white)),
                addVerticalSpace(height(context) * 0.04),
                SizedBox(
                  height: 55,
                  width: width(context) * 0.9,
                  child: CustomTextFormField(
                      error: "Enter Valid Email",
                      preffixIcon: Icon(Icons.person_outline),
                      controller: _username,
                      hintText: 'Email',
                      keyBoardType: TextInputType.name),
                ),
                addVerticalSpace(15),
                SizedBox(
                  height: 55,
                  width: width(context) * 0.9,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _password,
                    // onChanged:(value) =>  chng,
                    obscureText: !_passVisible,

                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white54,
                        ),
                        border: const OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: _passVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          color: Colors.white54,
                          onPressed: () {
                            setState(() {
                              _passVisible = !_passVisible;
                            });
                          },
                        ),
                        hintStyle:
                            const TextStyle(color: Colors.white, fontSize: 13),
                        filled: true,

                        // errorText: error,
                        fillColor: Colors.white12,
                        hintText: 'Password'),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    )),
                addVerticalSpace(25),
                CustomButton(
                    onTap: () async {
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _username.text,
                                password: _password.text);
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            'email', _username.toString());
                        isPremium = false;

                        var did = await getDeviceId();

                        print("devicex id is:" + did.toString());

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("device")
                            .doc("deviceID")
                            .get()
                            .then((e) async {
                          if (e.exists) {
                            final data = e.data;
                            print("devicex device is  reigiser :" +
                                data()!["device_Id"]);

                            if (e.data()!["device_Id"] == did) {
                              log(isPremium.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyBottomBar()));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "User login found in other device");
                              print(e.data()!["device_id"] + " :::::: " + did);
                            }
                          } else {
                            print("devicex device is not reigiser");

                            Map<String, dynamic> data = {"device_Id": did};

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("device")
                                .doc("deviceID")
                                .set(data)
                                .then((value) {
                              print("devicex id updated");

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyBottomBar()));
                            }).catchError((onError) {
                              print("devicex error to update device");
                            });
                          }
                        });
                      } on FirebaseAuthException catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                    textWidget: Center(
                      child: Text(
                        'Login',
                        style: bodyText16w600(color: black),
                      ),
                    )),
                addVerticalSpace(18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 1,
                      width: width(context) * 0.37,
                      color: Colors.grey.shade300,
                    ),
                    Text('Or'),
                    Container(
                      height: 1,
                      width: width(context) * 0.37,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                addVerticalSpace(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await FirebaseServices().signInWithGoogle(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: myOutlineBoxDecoration(
                            1, white.withOpacity(0.8), 14),
                        child: Center(
                          child: Image.asset('assets/images/google.png'),
                        ),
                      ),
                    ),
                    addHorizontalySpace(30),
                    InkWell(
                      onTap: () async {
                        print('===================================');
                        await FirebaseServices().signInWithFacebook();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MyBottomBar())));
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: myOutlineBoxDecoration(
                            1, white.withOpacity(0.8), 14),
                        child: Center(
                          child: Image.asset('assets/images/fb.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(height(context) * 0.04),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SignUpScreen())));
                    // Navigator.pop(context);
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(text: 'Don’t have an account yet? '),
                    TextSpan(text: 'Register', style: TextStyle(color: yellow))
                  ])),
                ),
                addVerticalSpace(height(context) * 0.02),
              ],
            ),
            iconOverlay()
          ],
        ),
      ),
    );
  }
}
