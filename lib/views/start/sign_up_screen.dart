// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
// import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:magnus_app/policies/pp.dart';
import 'package:magnus_app/policies/tou.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/utils/userModel.dart';
import 'package:magnus_app/views/home/home_screen.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';
import 'package:magnus_app/views/start/create_profile_screen.dart';
import 'package:magnus_app/views/start/log_in_screen.dart';
// import 'package:flutter_country_picker/flutter_country_picker.dart' as cntry;
import 'package:magnus_app/widget/custom_button_widget.dart';
// import 'package:restcountries/restcountries.dart';

import '../../services/firebase_authen.dart';
import '../../widget/custom_textformfield.dart';
import '../../widget/my_bottom_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController number = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController passwordCOn = TextEditingController();

  final TextEditingController otpController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String smsCode = 'xxxx';
  String verify = "";
  String? cityValue = "";
  String? stateValue = "";
  String? countryValue = "";

  bool isEmailVerified = false;
  bool verifSent = false;
  bool otpVerified = false;
  bool tapped = false;
  Timer? timer;

  var resOtp;

  var verifying = false;
  var _passVisible = false;

  String countryDrpVal = 'India';

  bool otpSent = false;
  bool verifiedOtp = false;

  // var api = RestCountries.setup(
  //     Platform.environment['827dd45b5d0980ffafe4166e60c7ebbd']);

  registerUser() async {
    // Create a PhoneAuthCredential with the code
    // PhoneAuthCredential credential =
    //     PhoneAuthProvider.credential(verificationId: code, smsCode: smsCode);

    // // Sign the user in (or link) with the credential
    // await auth.signInWithCredential(credential);
    final fireStore = FirebaseFirestore.instance;

    await fireStore
        .collection('users')
        .orderBy('displayName', descending: true)
        .get()
        .then((value) async {
      String displayName = value.docs.isNotEmpty
          ? value.docs.first.data()['displayName']
          : "000000000";
      int count = int.parse(displayName.substring(3, displayName.length));
      int values = count + 1;
      String d = "MCS${values.toString().padLeft(9, '0')}";
      FirebaseAuth.instance.currentUser!.updateDisplayName(d);
      log(displayName.substring(3, displayName.length));
      log(values.toString());
      log(d);
      users = Users(
        uid: auth.currentUser!.uid,
        fullName: firstNameController.text,
        email: email.text,
        profileImage: '',
        city: cityValue!,
        country: countryValue!,
        mobNum: number.text,
        pass: passwordCOn.text,
        invitationId: "",
        isPremium: false,
        freeCourses: [],
        purchasedCourses: [],
        videosWatched: [],
        dob: "",
        gender: "",
        premiumTill: '',
        displayName: d,
        id: d,
        joiningDate: "${DateTime.now()}",
      );

      Map<String, dynamic> mp = {
        'appNotif': false,
        'vidAlert': false,
        'appRate': 0.0,
        'rateCourse': 0.0,
      };

      var response = await http.get(Uri.parse(
          "https://moneysagaconsultancy.com/api/api/insert?user_id=$d&name=${firstNameController.text}&referal_id="
          "&position=left"));

      log("Api response1: ${response.statusCode}:${response.body}");

      await fireStore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('profile')
          .doc('myProfile')
          .set(
            mp,
          );
      await fireStore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(users.toMap())
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateProfileScreen()));
      });
    });
  }

  showSnackBar(BuildContext context, String str, [Color clr = Colors.black]) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(str),
      backgroundColor: clr,
    ));
  }

  verifyEmail() async {}

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  bool isChecked = false;
  bool isValidPassword = false;
  bool isValidEmail = false;
  User? u;

  String code = '';

  @override
  void initState() {
    _passVisible = false;
    // registerUser();
    // TODO: implement initState
    super.initState();
  }

  isPassValid(String? pass) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern.toString());
    isValidPassword = regex.hasMatch(pass!);
    setState(() {});
  }

  isEmailValid(String? email) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern.toString());
    isValidEmail = regex.hasMatch(email!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: height(context) * 1,
            width: width(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addVerticalSpace(height(context) * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            'Hey there,',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Create an Account',
                            style: bodyText20w700(color: yellow),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset("assets/images/LOG.png"),
                      )
                    ],
                  ),

                  addVerticalSpace(height(context) * 0.04),
                  SizedBox(
                    height: 55,
                    child: CustomTextFormField(
                      error: "Enter Valid Name",
                      preffixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white54,
                      ),
                      keyBoardType: TextInputType.name,
                      controller: firstNameController,
                      hintText: 'Full Name',
                    ),
                  ),
                  addVerticalSpace(15),
                  SizedBox(
                    height: 70,
                    child: IntlPhoneField(
                      decoration: const InputDecoration(
                        hintText: "Mobile Number",
                        contentPadding: EdgeInsets.only(top: 5),
                        hintStyle: TextStyle(color: Colors.white, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white12,
                        filled: true,
                      ),
                      showCountryFlag: false,
                      initialCountryCode: 'IN',
                      textAlignVertical: TextAlignVertical.center,
                      controller: number,
                      style: const TextStyle(fontSize: 14),
                      onCountryChanged: (x) {
                        countryDrpVal = x.name;
                        setState(() {});
                      },
                      onSubmitted: (number) async {},
                    ),
                  ),
                  addVerticalSpace(15),
                  Container(
                    width: width(context),
                    // height: 170,
                    child: Row(
                      children: [
                        Column(
                          //NOT WORKING!
                          children: [
                            Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    color: Colors.white12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(Icons.location_pin),
                                )),
                            addVerticalSpace(10),
                            Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    color: Colors.white12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(Icons.location_searching),
                                )),
                            addVerticalSpace(10),
                            Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    color: Colors.white12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(Icons.location_city),
                                )),
                          ],
                        ),
                        SizedBox(
                          width: width(context) * 0.82,
                          child: CSCPicker(
                            // defaultCountry: DefaultCountry.India,
                            countryDropdownLabel: "*Country",
                            stateDropdownLabel: "*State",
                            cityDropdownLabel: "*City",
                            layout: Layout.vertical,
                            selectedItemStyle: TextStyle(color: white),
                            defaultCountry: CscCountry.India,
                            dropdownDecoration: const BoxDecoration(
                                // width: 0.0 produces a thin "hairline" border

                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                color: Colors.white12),
                            flagState: CountryFlag.DISABLE,
                            disabledDropdownDecoration: const BoxDecoration(

                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                color: Colors.white12),
                            onCityChanged: (value) => setState(() {
                              cityValue = value;
                            }),
                            onCountryChanged: (value) => setState(() {
                              countryValue = value;
                            }),
                            onStateChanged: (value) => setState(() {
                              stateValue = value;
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   width: width(context),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  //     color: Colors.white12,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       const Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 9.0),
                  //         child: Icon(
                  //           Icons.add_location,
                  //           color: Colors.white54,
                  //         ),
                  //       ),
                  //       Container(
                  //         child: DropdownButton(
                  //           value: countryDrpVal,
                  //           items: listCountries.map((String items) {
                  //             return DropdownMenuItem(
                  //               value: items,
                  //               child: Text(
                  //                 items,
                  //                 style: TextStyle(fontSize: 13),
                  //               ),
                  //             );
                  //           }).toList(),
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               countryDrpVal = newValue!;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 8,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // addVerticalSpace(15),
                  // SizedBox(
                  //   height: 50,
                  //   child:
                  //       //  DropdownButton(
                  //       //   items: listCountries,
                  //       //   onChanged: (String? value) {},
                  //       // )
                  //       CustomTextFormField(
                  //     error: "Enter Valid City",
                  //     preffixIcon: const Icon(
                  //       Icons.location_city,
                  //       color: Colors.white54,
                  //     ),
                  //     keyBoardType: TextInputType.streetAddress,
                  //     controller: countryController,
                  //     hintText: 'City Name',
                  //     // ontap: () => getCountry(),
                  //   ),
                  // ),
                  addVerticalSpace(10),

                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,

                      // onChanged:(value) =>  chng,
                      obscureText: false,

                      onChanged: (value) {
                        isEmailValid(value);
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: Colors.white54,
                          ),
                          border: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: GestureDetector(
                            child: email.text.isNotEmpty
                                ? verifSent
                                    ? isEmailVerified
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : CircularProgressIndicator()
                                    : SizedBox()
                                : SizedBox(),
                            onTap: () async {},
                          ),
                          hintStyle: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          filled: true,

                          // errorText: error,
                          fillColor: Colors.white12,
                          hintText: 'Email'),
                    ),
                  ),
                  email.text.isNotEmpty && verifSent && !isEmailVerified
                      ? Text(
                          "Please verify your email via link sent!",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : SizedBox(),
                  addVerticalSpace(5),
                  email.text.isNotEmpty && !isValidEmail
                      ? Text(
                          "Enter valid email",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : SizedBox(),
                  addVerticalSpace(5),
                  SizedBox(
                    height: 55,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: passwordCOn,
                      // onChanged:(value) =>  chng,
                      obscureText: !_passVisible,
                      validator: (value) => isValidPassword
                          ? null
                          : 'Password must contain atleast 8 characters, a small letter, a capital letter, a number and a special character',
                      onChanged: (value) {
                        isPassValid(value);
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.white54,
                          ),
                          border: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                          hintStyle: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          filled: true,

                          // errorText: error,
                          fillColor: Colors.white12,
                          hintText: 'Password'),
                    ),
                  ),
                  addVerticalSpace(5),
                  passwordCOn.text.isNotEmpty && !isValidPassword
                      ? Text(
                          'Password must contain atleast 8 characters, a small letter, a capital letter, a number and a special character',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : SizedBox(),
                  addVerticalSpace(5),
                  Column(
                    children: [
                      SizedBox(
                        width: width(context),
                        height: 55,
                        child: CustomTextFormField(
                          preffixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.white54,
                          ),
                          keyBoardType: TextInputType.number,
                          controller: otpController,
                          hintText: 'OTP Sent to Your Mobile',
                          error: "Enter Valid OTP",
                          suffixText: GestureDetector(
                            child: Column(
                              children: [
                                !otpVerified
                                    ? Text(
                                        otpSent ? 'Resend OTP' : 'Send OTP',
                                        style: bodyText12Small(color: yellow),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                              ],
                            ),
                            onTap: () async {
                              send_otp(number.text);
                              print('$resOtp ----------------------------');
                              // log(smsCode);
                              // await FirebaseAuth.instance.verifyPhoneNumber(
                              //   phoneNumber: "+91${number.text}",
                              //   verificationCompleted:
                              //       (PhoneAuthCredential credential) async {
                              //     // await auth.signInWithCredential(credential);
                              //   },
                              //   verificationFailed: (FirebaseAuthException e) {
                              //     if (e.code == 'invalid-phone-number') {
                              //       String s = "+91${number.text}";
                              //       print('The provided phone number is not valid.');
                              //       showSnackBar(context, "Enter Valid Phone Number $s",
                              //           Colors.white);
                              //     }
                              //   },
                              //   codeSent:
                              //       (String verificationId, int? resendToken) async {
                              //     showSnackBar(
                              //         context,
                              //         'Please check your phone for the verification code.',
                              //         Colors.white);
                              //     String smsCode = otpController.text;

                              //     code = verificationId;
                              //     print(verificationId);
                              //     setState(() {});
                              //   },
                              //   timeout: Duration(seconds: 60),
                              //   codeAutoRetrievalTimeout: (String verificationId) {},
                              // );
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: otpSent,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          child: InkWell(
                              onTap: () async {
                                if (otpController.text.length >= 6) {
                                  var status = await FirebaseAuth.instance
                                      .signInWithCredential(
                                          PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: otpController.text,
                                  ))
                                      .catchError((onError) {
                                    Fluttertoast.showToast(
                                        msg: "Error: " + onError.toString());
                                  });

                                  if (status.user!.uid != null) {
                                    otpVerified = true;

                                    Fluttertoast.showToast(
                                        msg: "Otp Verification done");

                                    setState(() {});
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Something is wrong");
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please Enter Valid otp");
                                }
                              },
                              child: Text("Verify")),
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(8),
                  Row(
                    children: [
                      Checkbox(
                          value: isChecked,
                          checkColor: black,
                          activeColor: white,
                          onChanged: (value) {
                            setState(() {});
                            isChecked = !isChecked;
                          }),
                      SizedBox(
                          width: width(context) * 0.6,
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'By continuing you accept our ',
                                style: TextStyle(fontSize: 12)),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PolicyScreen()));
                                },
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline),
                            ),
                            TextSpan(
                                text: ' and ', style: TextStyle(fontSize: 12)),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => TermScreen()));
                                },
                              text: 'Term of Use',
                              style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline),
                            )
                          ])))
                    ],
                  ),
                  addVerticalSpace(25),
                  CustomButton(
                      onTap: () async {
                        if (isChecked) {
                          try {
                            if (firstNameController.text.isNotEmpty &&
                                number.text.isNotEmpty &&
                                email.text.isNotEmpty &&
                                passwordCOn.text.isNotEmpty &&
                                cityValue!.isNotEmpty &&
                                countryValue!.isNotEmpty &&
                                cityValue!.isNotEmpty &&
                                cityValue!.isNotEmpty &&
                                otpController.text.isNotEmpty) {
                              if (isChecked) {
                                if (otpVerified) {
                                  setState(() {
                                    tapped = true;
                                    sendVerifMail();
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Otp Verification is Pending");
                                  setState(() {
                                    tapped = false;
                                  });
                                }
                                // if (resOtp == otpController.text ||
                                //     otpController.text == '123456789') {
                                //   setState(() {
                                //     otpVerified = true;
                                //   });
                                //   setState(() {
                                //     tapped = true;
                                //   });
                                //   sendVerifMail();
                                // } else {
                                //   setState(() {
                                //     tapped = false;
                                //   });
                                //   showSnackBar(context, 'Enter Correct Otp.', white);
                                // }
                              } else {
                                showSnackBar(
                                    context,
                                    'Please agree terms and conditions.',
                                    white);
                              }
                            } else {
                              showSnackBar(
                                  context, 'Enter all details first.', white);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showSnackBar(context,
                                  'The password provided is too weak.', white);
                            } else if (e.code == 'email-already-in-use') {
                              showSnackBar(
                                  context,
                                  'The account already exists for that email.',
                                  white);
                            }
                          } catch (e) {
                            print(e);
                            showSnackBar(
                                context, "Please fill all details", white);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please accept privacy policy");
                        }
                      },
                      textWidget: Center(
                        child: tapped || verifying
                            ? const CircularProgressIndicator()
                            : Text(
                                'Register',
                                style: bodyText16w600(color: black),
                              ),
                      )),
                  addVerticalSpace(18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 1,
                        width: width(context) * 0.4,
                        color: Colors.grey.shade300,
                      ),
                      Text('Or'),
                      Container(
                        height: 1,
                        width: width(context) * 0.4,
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
                      // InkWell(
                      //   onTap: () async {
                      //     print("lllllllllllllllllllllllllllllllllllll");
                      //     await FirebaseServices().signInWithFacebook();

                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: ((context) => MyBottomBar())));
                      //   },
                      //   child: Container(
                      //     height: 50,
                      //     width: 50,
                      //     decoration:
                      //         myOutlineBoxDecoration(1, white.withOpacity(0.8), 14),
                      //     child: Center(
                      //       child: Image.asset('assets/images/fb.png'),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  addVerticalSpace(height(context) * 0.04),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScreen()));
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(text: 'Login', style: TextStyle(color: yellow))
                    ])),
                  ),
                  addVerticalSpace(height(context) * 0.02),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  checkEmailVerified() async {
    // log();
    print('8');
    // user = ;
    // showAlertDialog(context);
    FirebaseAuth.instance.currentUser!.reload();
    log(FirebaseAuth.instance.currentUser!.toString());

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    setState(() {});
    print(isEmailVerified);

    if (isEmailVerified) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));

      timer?.cancel();

      registerUser();
    }
  }

  void sendVerifMail() async {
    try {
      UserCredential result = await auth
          .createUserWithEmailAndPassword(
              email: email.text, password: passwordCOn.text)
          .catchError((e) {
        showSnackBar(context, e.toString(), Colors.white);
        setState(() {
          tapped = false;
        });
      });
      // final User user = result.user!;
      UserCredential u = await auth.signInWithEmailAndPassword(
          email: email.text, password: passwordCOn.text);
      User? user = u.user;
      user!.updateEmail(email.text);
      if (user != null) {
        await user.sendEmailVerification().catchError((err) {
          log('Error: $err'); // Prints 401.
        });
        print(user.toString());
        showSnackBar(
            context,
            "Logging to Account! Verification Email Sent, Please verify!",
            Colors.white);
        setState(() {
          verifSent = true;
          tapped = false;
        });

        timer = Timer.periodic(
            const Duration(seconds: 3), (_) => checkEmailVerified());

        // setState(() {});
      } else {
        setState(() {});
      }
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            // <-- SEE HERE
            title: const Text('Verify Email'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'Follow the link in mailbox to verify your email address.'),
                ],
              ),
            ),
            actions: <Widget>[
              isEmailVerified
                  ? Text('Please verify Email')
                  : CircularProgressIndicator()
            ],
          ),
        );
      },
    );
  }

  String phoneNumber = "", verificationId = "";
  String otp = "", authStatus = "";

  Future<void> verifyPhoneNumber(BuildContext context, String mobo) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + mobo,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (Exception authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
        log("OTP Verification Failed: $authException");
      },
      codeSent: (vid, forceResendingToken) {
        setState(() {
          verificationId = vid;

          otpSent = true;
        });

        Fluttertoast.showToast(msg: "OTP sent to your number");
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  send_otp(String phoneNo) async {
    verifyPhoneNumber(context, phoneNo);
    // var otp_res = '';

    // var api_key = "11ae3240-b02f-11ed-813b-0200cd936042";

    // var respoText;
    // var r;
    // final res = await http
    //     .get(Uri.parse(
    //         'https://2factor.in/API/V1/$api_key/SMS/+91${phoneNo}/AUTOGEN2/OTP1'))
    //     .then((value) => respoText = value.body)
    //     .then((val) => jsonDecode(val))
    //     .then((result) {
    //   otp_res = result["OTP"];
    //   return result["OTP"];
    // }).catchError((error) => log('$error'));
    // if (res == null) {
    //   var parts = respoText.split(':');
    //   var prefix = parts[2].trim();
    //   String re = prefix.substring(1, prefix.toString().length - 2);
    //   showSnackBar(context, re, white);
    //   otpController.clear();
    // } else {
    //   setState(() {
    //     otpSent = true;
    //   });
    //   log(
    //     "opt_res $otp_res",
    //   );

    //   Fluttertoast.showToast(msg: "OTP sent on your number");
    //   resOtp = otp_res;
    //   setState(() {});
    // }
  }

  showAlertDialog(BuildContext context) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Verify Email"),
      content: Text("Follow sent link to verify your email address."),
      actions: [
        isEmailVerified ? CircularProgressIndicator() : Text("Verified")
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void openList(List list) {
    showDialog(
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, int index) {
            return ListTile(
              title: _buildRow(list[index]),
            );
          },
        );
      },
      context: context,
    );
  }

  Widget _buildRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 12),
          Container(height: 2, color: Colors.redAccent),
          SizedBox(height: 12),
          Row(
            children: <Widget>[Text(name)],
          ),
        ],
      ),
    );
  }
}
