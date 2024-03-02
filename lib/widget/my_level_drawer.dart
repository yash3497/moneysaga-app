import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/humburger_items/event_photos_screen.dart';
import 'package:magnus_app/views/humburger_items/events_videos_screen.dart';
import 'package:magnus_app/views/humburger_items/live_meetings_screen.dart';
import 'package:magnus_app/views/humburger_items/my_Premium_Learning.dart';
import 'package:magnus_app/views/humburger_items/my_learning.dart';
import 'package:magnus_app/views/humburger_items/updates_screen.dart';

import '../views/home/cmd_message_screen.dart';
import '../views/start/premium_screen.dart';

class MyLevelDrawer extends StatefulWidget {
  
  const MyLevelDrawer({super.key});

  @override
  State<MyLevelDrawer> createState() => _MyLevelDrawerState();
}

class _MyLevelDrawerState extends State<MyLevelDrawer> {
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
      width: width(context) * 0.75,
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
                          style: bodyText20w700(color: yellow),
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
                addVerticalSpace(height(context)*0.08),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyPremiumLearningScreen( level: 'basic',)));
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
                        'Basic',
                        style: bodyText16w600(color: yellow),
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
                            builder: (context) => MyPremiumLearningScreen( level: 'advance',)));
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
                        'Advance',
                        style: bodyText16w600(color: yellow),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
