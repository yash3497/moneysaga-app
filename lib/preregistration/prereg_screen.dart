import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:magnus_app/utils/constant.dart';

import '../utils/userModel.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_textformfield.dart';

class PreRegScreen extends StatefulWidget {
  const PreRegScreen({super.key});

  @override
  State<PreRegScreen> createState() => _PreRegScreenState();
}

class _PreRegScreenState extends State<PreRegScreen> {
  String title = '', title2 = '', title3 = '';
  String imageLink = '';

  final TextEditingController _name = TextEditingController(),
      _email = TextEditingController(),
      _mobileNum = TextEditingController(),
      _country = TextEditingController(),
      _city = TextEditingController();
  final TextEditingController _otpCont = TextEditingController();

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
  String cityValue = "";
  String stateValue = "";
  String countryValue = "";

  bool isEmailVerified = false;
  bool otpVerified = false;
  bool isRegistered = false;
  Timer? timer;

  var verifying = false;
  var _passVisible = false;

  String countryDrpVal = 'India';

  List premiumPlan = [
    {
      'title': 'Forex Market Education (A)',
      'original price': '',
      'discPrice': '15000',
      'usd': '245'
    },
    {
      'title': 'Indian Stock Market Education (B)',
      'original price': '',
      'discPrice': '15000',
      'usd': '245'
    },
    {
      'title': 'Combo Course (A+B)',
      'original price': '',
      'discPrice': '25000',
      'usd': '405'
    }
  ];
  String plan = '';
  int currentIndex = 0;

  @override
  void initState() {
    getPreRegData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: Image.asset('assets/images/prereg_logo.png'),
              ),
            ),
            addVerticalSpace(height(context) * 0.04),
            Text(title, style: bodyText28W600(color: yellow)),
            addVerticalSpace(height(context) * 0.04),
            Text(
              title3,
              style: bodyText14normal(color: white),
            ),
            addVerticalSpace(height(context) * 0.02),
            SizedBox(
              height: height(context) * 0.2,
              width: width(context) * 0.9,
              child: Expanded(
                child: ListView.builder(
                    itemCount: premiumPlan.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      print('vjbdjbhvjhbd');
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
                              width: width(context) * 0.281,
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                  border: currentIndex == index
                                      ? Border.all(color: yellow, width: 2)
                                      : Border()),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(0.8),
                                      child: Center(
                                        child: Text(
                                          premiumPlan[index]['title'],
                                          style: bodyText14w600(
                                              color: currentIndex == index
                                                  ? yellow
                                                  : white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   child: Column(
                                  //     children: [
                                  //       // Text(
                                  //       //   'Rs. ${premiumPlan[index]['discPrice']}+GST',
                                  //       //   style: bodyText16w600(
                                  //       //       color: currentIndex == index
                                  //       //           ? yellow
                                  //       //           : white),
                                  //       // ),
                                  //       // Text(
                                  //       //   '(USD ${premiumPlan[index]['usd']})',
                                  //       //   style: bodyText16w600(
                                  //       //       color: currentIndex == index
                                  //       //           ? yellow
                                  //       //           : white),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            addHorizontalySpace(10)
                          ],
                        ),
                      );
                    }),
              ),
            ),
            addVerticalSpace(height(context) * 0.07),
            Text(
              title2,
              style: bodyText14normal(color: white),
            ),
            addVerticalSpace(height(context) * 0.01),
            SizedBox(
              height: 50,
              width: width(context) * 0.9,
              child: CustomTextFormField(
                  error: "Enter Valid Username",
                  preffixIcon: Icon(Icons.person_outline),
                  controller: _name,
                  hintText: 'Full Name',
                  keyBoardType: TextInputType.name),
            ),
            addVerticalSpace(15),
            SizedBox(
              height: 50,
              width: width(context) * 0.9,
              child: CustomTextFormField(
                error: "enter correct password",
                preffixIcon: Icon(Icons.lock_outline),
                controller: _email,
                hintText: 'Email Id',
                keyBoardType: TextInputType.emailAddress,
              ),
            ),
            addVerticalSpace(15),
            Container(
              width: width(context) * 0.9,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white12,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9.0),
                    child: Icon(
                      Icons.add_location,
                      color: Colors.white54,
                    ),
                  ),
                  Container(
                    width: width(context) * 0.79,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        isExpanded: false,
                        value: countryDrpVal,
                        items: listCountries.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            countryDrpVal = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
            addVerticalSpace(15),
            SizedBox(
              width: width(context) * 0.9,
              height: 50,
              child:
                  //  DropdownButton(
                  //   items: listCountries,
                  //   onChanged: (String? value) {},
                  // )
                  CustomTextFormField(
                error: "Enter Valid City",
                preffixIcon: const Icon(
                  Icons.location_city,
                  color: Colors.white54,
                ),
                keyBoardType: TextInputType.streetAddress,
                controller: _city,
                hintText: 'City Name',
                // ontap: () => getCountry(),
              ),
            ),
            addVerticalSpace(15),
            SizedBox(
              width: width(context) * 0.9,
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
                controller: _mobileNum,
                style: const TextStyle(fontSize: 14),
                onCountryChanged: (x) {
                  countryDrpVal = x.name;
                  setState(() {});
                },
                onSubmitted: (number) async {},
              ),
            ),
            addVerticalSpace(15),
            CustomButton(
                onTap: () async {
                  try {
                    registerUser();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      showSnackBar(
                          context, 'The password provided is too weak.', white);
                    } else if (e.code == 'email-already-in-use') {
                      showSnackBar(context,
                          'The account already exists for that email.', white);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                textWidget: Center(
                  child: verifying
                      ? const CircularProgressIndicator()
                      : Text(
                          'Register',
                          style: bodyText16w600(color: black),
                        ),
                )),
            addVerticalSpace(15),
          ],
        ),
      ),
    ));
  }

  showSnackBar(BuildContext context, String str, [Color clr = Colors.black]) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(str),
      backgroundColor: clr,
    ));
  }

  void getPreRegData() async {
    var x = await FirebaseFirestore.instance
        .collection('preregistration')
        .doc('status')
        .get();
    title = x.data()!['text'];
    title2 = x.data()!['text2'];
    title3 = x.data()!['text3'];
    imageLink = x.data()!['url'];

    setState(() {});
  }

  void registerUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('displayName', descending: true)
        .get()
        .then((value) async {
      String displayName =
          value.docs.first.data()['displayName'] ?? "0000000000";
      int count = int.parse(displayName.substring(3, 10));
      String d = "MCS${count + 1}";
      users = Users(
          uid: '',
          fullName: _name.text,
          email: _email.text,
          profileImage: '',
          city: _city.text,
          country: countryDrpVal,
          mobNum: _mobileNum.text,
          pass: '',
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
          joiningDate: '${DateTime.now()}');
      await FirebaseFirestore.instance
          .collection('preregistration')
          .doc('preregisterUserDetails')
          .collection('usersDetail')
          .add(users.toMap());
      _name.clear();
      _city.clear();
      _country.clear();
      _mobileNum.clear();
      _email.clear();
      _otpCont.clear();
      showSnackBar(context, "Registered! Thank you for registering...", white);
      setState(() {});
    });
  }
}
