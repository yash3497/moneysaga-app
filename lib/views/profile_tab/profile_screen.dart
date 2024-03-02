// import 'dart:math';

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/profile_tab/edit_profile.dart';
import 'package:magnus_app/views/start/log_in_screen.dart';
import 'package:magnus_app/views/start/premium_screen.dart';
import 'package:magnus_app/views/start/splash_screen.dart';
import 'package:magnus_app/widget/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../views/home/cmd_message_screen.dart';

import '../../services/firebase_authen.dart';
import '../../utils/userModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool isSwitch = false;
  bool isSwitch2 = false;
  String name = '';

  double appRate = 0.0;
  double courseRate = 0.0;

  void getData() async {
    var profile = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // purchasedCourse = profile.data()?['purchasedCourses'];

    name = profile.data()?['fullName'];
    print(name + '----------');
  }

  Map<String, dynamic> mp = {};
  String website = 'moneysagaconsultancy.com';

  getProfileSite() async {
    var x = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('profile')
        .doc('myProfile')
        .get();
    mp = x.data()!;
    var y = await FirebaseFirestore.instance
        .collection('website')
        .doc('k7Puw57OKBzlNOEgkM3b')
        .get();
    website = y.data()!['website'] ?? 'moneysagaconsultancy.com';
    log(mp.toString());
    log(website.toString());

    appRate = double.parse('${mp['appRate'] ?? 0}');
    courseRate = double.parse('${mp['rateCourse'] ?? 0}');
    log(appRate.toString());
    isSwitch = mp['appNotif'];
    isSwitch2 = mp['vidAlert'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isPremium();
    getProfileSite();
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void isPremium() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var x = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      x.get().then((value) async {
        if (value.exists) {
          users = Users.fromDocument(value);
          setState(() {});
        } else {
          MaterialPageRoute(builder: (context) => LogInScreen());
          FirebaseAuth.instance.signOut();
        }
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: black.withOpacity(0.1),
        title: Text('My Profile'),
        leading: IconButton(
            onPressed: () {
              _globalKey.currentState!.openDrawer();
            },
            icon: const ImageIcon(AssetImage('assets/images/main.png'))),
        actions: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset("assets/images/LOG.png"),
          )
        ],
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(12),
            height: height(context) * 0.15,
            width: width(context) * 0.9,
            decoration: myFillBoxDecoration(0, boxBgColor, 10),
            child: Row(
              children: [
                users.profileImage == '' ||
                        users.profileImage == null ||
                        users.profileImage == ' '
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/myprofile.png'),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(users.profileImage),
                      ),
                addHorizontalySpace(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: width(context) * 0.38,
                          child: Text(
                            users.fullName ?? 'User',
                            style: bodyText16w600(color: white),
                          ),
                        ),
                        // IconButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   EditProfileScreen()));
                        //     },
                        //     icon:
                        //         ImageIcon(AssetImage('assets/images/edit.png')))
                      ],
                    ),
                    // addVerticalSpace(5),
                    users.isPremium == null
                        ? Text(
                            'Free user',
                            style: TextStyle(color: yellow),
                          )
                        : Text(
                            !users.isPremium ? 'Free user' : 'Premium user',
                            style: TextStyle(color: yellow),
                          ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PremiumScreen()));
                      },
                      child: Text(
                        !users.isPremium
                            ? 'Buy premium'
                            : 'Valid till ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse(users.premiumTill != "" ? users.premiumTill : "1701323186000")))}',
                        style: bodyText12Small(color: white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(12),
            height: height(context) * 0.23,
            width: width(context) * 0.9,
            decoration: myFillBoxDecoration(0, boxBgColor, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      color: yellow,
                    ),
                    addHorizontalySpace(10),
                    Text(
                      'Settings',
                      style: TextStyle(
                          color: yellow,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: white.withOpacity(0.5),
                ),
                ListTile(
                  title: Text(
                    'App Notifications',
                    style: bodyText14normal(color: white),
                  ),
                  trailing: Switch(
                      activeColor: yellow,
                      value: isSwitch,
                      onChanged: (value) async {
                        setState(() {
                          isSwitch = value;
                        });
                        mp['appNotif'] = isSwitch;
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('profile')
                            .doc('myProfile')
                            .set(
                              mp,
                            );
                      }),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: white.withOpacity(0.5),
                ),
                ListTile(
                  title: Text(
                    'New Video Alerts',
                    style: bodyText14normal(color: white),
                  ),
                  trailing: Switch(
                      activeColor: yellow,
                      value: isSwitch2,
                      onChanged: (value) async {
                        setState(() {
                          isSwitch2 = value;
                        });
                        mp['vidAlert'] = isSwitch2;
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('profile')
                            .doc('myProfile')
                            .set(
                              mp,
                            );
                      }),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 5),
            padding: EdgeInsets.all(12),
            height: height(context) * 0.15,
            width: width(context) * 0.9,
            decoration: myFillBoxDecoration(0, boxBgColor, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Rate the Application',
                      style: bodyText14normal(color: white),
                    ),
                    addHorizontalySpace(10),
                    RatingBar.builder(
                      initialRating: appRate,
                      minRating: 1,
                      itemSize: 25,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: Color.fromRGBO(254, 173, 29, 0.4),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromRGBO(254, 173, 29, 1),
                      ),
                      onRatingUpdate: (rating) async {
                        mp['appRate'] = rating;
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('profile')
                            .doc('myProfile')
                            .set(
                              mp,
                            );
                      },
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: white.withOpacity(0.5),
                ),
                Row(
                  children: [
                    Text(
                      'Rate the Course',
                      style: bodyText14normal(color: white),
                    ),
                    addHorizontalySpace(width(context) * 0.123),
                    RatingBar.builder(
                      initialRating: courseRate,
                      minRating: 1,
                      itemSize: 25,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: Color.fromRGBO(254, 173, 29, 0.4),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromRGBO(254, 173, 29, 1),
                      ),
                      onRatingUpdate: (rating) async {
                        mp['rateCourse'] = rating;
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('profile')
                            .doc('myProfile')
                            .set(
                              mp,
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _launchInBrowser(Uri.parse('http://$website')),
            child: Container(
              margin: EdgeInsets.only(bottom: 15, top: 5),
              padding: EdgeInsets.all(12),
              height: height(context) * 0.06,
              width: width(context) * .9,
              decoration: myFillBoxDecoration(0, boxBgColor, 10),
              child: Row(
                children: [
                  Text(
                    'Websites: ',
                    style: bodyText12normal(color: yellow),
                  ),
                  Text(
                    website,
                    style: bodyText12normal(color: white),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (FirebaseAuth.instance.currentUser != null) {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                Fluttertoast.showToast(msg: "Login out from device");

                FirebaseFirestore.instance.collection("users")
                  ..doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("device")
                      .doc("deviceID")
                      .delete()
                      .then((value) {
                    print("devicex id Removed");

                    Fluttertoast.showToast(msg: "logout done");

                    sharedPreferences.remove('email');
                    sharedPreferences.clear();

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return SplashScreen();
                    }), (route) => false);
                  }).catchError((onError) {
                    print("devicex error to remove device");
                  });

                await FirebaseAuth.instance.signOut();
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.all(12),
              height: height(context) * 0.06,
              width: width(context) * 0.9,
              decoration: myFillBoxDecoration(0, boxBgColor, 10),
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 18,
                      ),
                      addHorizontalySpace(5),
                      Text(
                        'Logout',
                        style: bodyText12w600(color: yellow),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
