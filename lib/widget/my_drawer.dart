import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/humburger_items/awards.dart';
import 'package:magnus_app/views/humburger_items/event_photos_screen.dart';
import 'package:magnus_app/views/humburger_items/events_videos_screen.dart';
import 'package:magnus_app/views/humburger_items/live_meetings_screen.dart';
import 'package:magnus_app/views/humburger_items/my_learning.dart';
import 'package:magnus_app/views/humburger_items/updates_screen.dart';
import 'package:magnus_app/widget/my_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home/cmd_message_screen.dart';
import '../views/start/premium_screen.dart';
import '../views/start/splash_screen.dart';
import 'my_level_drawer.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final List EventsPhotos = [
    {'title': 'Award Function', 'img': 'assets/images/event1.png'},
    {'title': 'Grand Event At Goa', 'img': 'assets/images/event2.png'}
  ];
  final List awardsRecog = [
    {'title': 'Ranjan Kumar', 'img': 'assets/images/awrd1.png'},
    {'title': 'Vineetha Rajni', 'img': 'assets/images/awrd2.png'}
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: black,
      width: width(context) * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addVerticalSpace(height(context) * 0.07),
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: myOutlineBoxDecoration(0, white, 70),
                      child: users.profileImage == '' ||
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
                    ),
                    addHorizontalySpace(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          users.fullName,
                          style: bodyText20w700(color: yellow)
                              .copyWith(fontSize: 16),
                        ),
                        Text(
                          !users.isPremium ? 'Free user' : 'Premium user',
                          style: TextStyle(color: yellow),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PremiumScreen()));
                          },
                          child: Text(
                            !users.isPremium
                                ? 'Buy premium'
                                : 'Valid till: 22-oct-2023',
                            style: bodyText12Small(color: white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                addVerticalSpace(height(context) * 0.08),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyBottomBar()));
                  },
                  child: Row(
                    children: [
                      ImageIcon(
                          color: yellow,
                          const AssetImage(
                            'assets/images/menu1.png',
                          )),
                      addHorizontalySpace(10),
                      Text(
                        'CEO Message',
                        style: bodyText14w600(color: yellow),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyLearningScreen(
                                  title: 'Free Learning - 03 Videos',
                                )));
                  },
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                          color: yellow,
                          const AssetImage(
                            'assets/images/menu2.png',
                          )),
                      addHorizontalySpace(10),
                      Text(
                        'Free Learning',
                        style: bodyText14w600(color: yellow),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyLevelDrawer()));
                  },
                  child: Row(
                    children: [
                      ImageIcon(
                          color: yellow,
                          AssetImage(
                            'assets/images/menu3.png',
                          )),
                      addHorizontalySpace(10),
                      Text(
                        'My Premium Learning',
                        style: bodyText14w600(color: yellow),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventsVideosScreen()));
                  },
                  child: Row(
                    children: [
                      ImageIcon(
                          color: yellow,
                          AssetImage(
                            'assets/images/menu5.png',
                          )),
                      addHorizontalySpace(10),
                      Text(
                        'Event Videos',
                        style: bodyText14w600(color: yellow),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventsAndAwardsPhotoWidget(
                                  title: 'Event Photos',
                                  listEventsandAwards: EventsPhotos,
                                )));
                  },
                  child: Row(
                    children: [
                      ImageIcon(
                          color: yellow,
                          AssetImage(
                            'assets/images/menu6.png',
                          )),
                      addHorizontalySpace(10),
                      Text(
                        'Event Photos',
                        style: bodyText14w600(color: yellow),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllAwards()));
                  },
                  child: Row(
                    children: [
                      ImageIcon(
                          color: yellow,
                          AssetImage(
                            'assets/images/menu7.png',
                          )),
                      addHorizontalySpace(10),
                      Text(
                        'Awards & Recognitions',
                        style: bodyText14w600(color: yellow),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatesScreen()));
                  },
                  child: Row(
                    children: [
                      ImageIcon(
                          color: yellow,
                          const AssetImage(
                            'assets/images/menu8.png',
                          )),
                      addHorizontalySpace(10),
                      Text(
                        'Updates',
                        style: bodyText14w600(color: yellow),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveMeetingsScreen()));
                  },
                  child: Row(
                    children: [
                      ImageIcon(
                          color: yellow,
                          const AssetImage(
                            'assets/images/menu9.png',
                          )),
                      addHorizontalySpace(10),
                      Text('Live Meetings',
                          style: bodyText14w600(color: yellow))
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                InkWell(
                  onTap: () async {
                    if (FirebaseAuth.instance.currentUser != null) {
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();

                      Fluttertoast.showToast(msg: "Login out from device");

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
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
                    }
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: yellow,
                          ),
                          addHorizontalySpace(10),
                          Text(
                            'Logout',
                            style: bodyText14w600(color: yellow),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.07),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: myFillBoxDecoration(0, yellow, 40),
                    child: Icon(
                      Icons.close,
                      color: black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
