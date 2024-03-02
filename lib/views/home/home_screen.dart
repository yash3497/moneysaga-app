import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/utils/methods.dart';
import 'package:magnus_app/utils/userModel.dart';
import 'package:magnus_app/views/home/cmd_message_screen.dart';
import 'package:magnus_app/views/my_learning_tab/my_course_screen.dart';
import 'package:magnus_app/views/start/log_in_screen.dart';
import 'package:magnus_app/views/start/premium_screen.dart';
import 'package:magnus_app/widget/my_drawer.dart';
import 'package:magnus_app/widget/video_player_widget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String url = "";
String title = "";
String name = "";
String profession = "";
String discription = "";
List<String> purchasedCourse = [''];
bool premium = false;

class _HomeScreenState extends State<HomeScreen> {
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

  int currentLangIndex = 0;
  int currentLevelIndex = 0;
  List language = ['English', 'Hindi'];
  List level = ['Basic', 'Ad'];
  void getDetails() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var profile = await FirebaseFirestore.instance
          .collection('bannerVideo')
          .doc("m46tgxWdhy9QVouzSuNE")
          .get();
      url = profile.data()?['videoUrl'];
      name = profile.data()?['publisherName'];
      profession = profile.data()?['publisherDiscription'];
      discription = profile.data()?['discription'];
      title = profile.data()?['title'];
      setState(() {});
    }
  }

  @override
  void initState() {
    isPremium();
    getDetails();
    getFreeCourses();
    // getPremiumCourses();
    // print('----------- course $freeCourseDetails');
    setState(() {});

    // TODO: implement initState
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => MyDrawer()));

              _scaffoldkey.currentState!.openDrawer();
            },
            icon: ImageIcon(AssetImage('assets/images/main.png'))),
        toolbarHeight: 60,
        elevation: 0,
        title: Text(
          'Message From CEO',
          style: TextStyle(color: yellow),
        ),

        actions: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset("assets/images/LOG.png"),
          )
        ],

        // title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //   const Text('New message'),
        //   Text(
        //     'From CMD',
        //     style: TextStyle(fontSize: 14, color: yellow),
        //   )
        // ]),
      ),
      drawer: const MyDrawer(),
      drawerDragStartBehavior: DragStartBehavior.start,
      body: Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(8),
                height: height(context) * 0.37,
                width: width(context) * 0.95,
                decoration:
                    myFillBoxDecoration(0, Colors.white.withOpacity(0.1), 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CmdMessageScreen()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 180,
                        width: width(context) * 0.9,
                        child: VideoPlayerScreen(
                          videoUrl: "$url",
                        ),
                      ),
                      addVerticalSpace(12),
                      Text(
                        '$title',
                        style: bodyText16w600(color: yellow),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 50,
                          child: Text(
                            '$discription',
                            style: bodyText14normal(color: white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              addVerticalSpace(10),
              Text(
                'My Course',
                style: bodyText20w700(color: white),
              ),
              Text(
                'Pick up where you left off',
                style: TextStyle(color: yellow),
              ),
              addVerticalSpace(10),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  bottom: 8,
                  left: width(context) * 0.16,
                ),
                height: height(context) * 0.04,
                child: ListView.builder(
                    itemCount: language.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentLangIndex = index;
                                currentLevelIndex = 0;
                              });
                            },
                            child: Container(
                              height: height(context) * 0.04,
                              width: width(context) * 0.27,
                              decoration: currentLangIndex == index
                                  ? myFillBoxDecoration(0, yellow, 20)
                                  : myOutlineBoxDecoration(1, white, 20),
                              child: Center(
                                child: Text(
                                  language[index],
                                  style: bodyText16w600(
                                      color: currentLangIndex == index
                                          ? black
                                          : white),
                                ),
                              ),
                            ),
                          ),
                          addHorizontalySpace(20)
                        ],
                      );
                    }),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 8,
                  left: currentLangIndex == 1 ? width(context) * 0.3 : 0,
                ),
                height: height(context) * 0.04,
                child: ListView.builder(
                    itemCount: level.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentLevelIndex = index;
                              });
                            },
                            child: Container(
                              height: height(context) * 0.04,
                              width: width(context) * 0.27,
                              decoration: currentLevelIndex == index
                                  ? myFillBoxDecoration(0, yellow, 20)
                                  : myOutlineBoxDecoration(1, white, 20),
                              child: Center(
                                child: Text(
                                  level[index],
                                  style: bodyText16w600(
                                      color: currentLevelIndex == index
                                          ? black
                                          : white),
                                ),
                              ),
                            ),
                          ),
                          addHorizontalySpace(20)
                        ],
                      );
                    }),
              ),
              addVerticalSpace(15),
              SizedBox(
                height: height(context) * 0.78,
                child: ListView.builder(
                    itemCount: freeCourseDetails.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      int k = i + 1;

                      var courseName = freeCourseDetails[i][5];
                      var courseDesc = freeCourseDetails[i][3];
                      var courseURL = freeCourseDetails[i][7] ??
                          "https://firebasestorage.googleapis.com/v0/b/magnus-app-7005a.appspot.com/o/video%2Firon.mp4?alt=media&token=c3509660-91db-43df-aadf-19169831676f";

                      // print('============ $courseName');

                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(8),
                        height: height(context) * 0.38,
                        width: width(context) * 0.95,
                        decoration: myFillBoxDecoration(
                            0, Colors.white.withOpacity(0.1), 15),
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MyCourseScreen(freeCourseDetails[i])));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 180,
                                width: width(context) * 0.9,
                                child:
                                    VideoPlayerScreen(videoUrl: '$courseURL'),
                              ),
                              addVerticalSpace(12),
                              Text(
                                'Video $k : $courseName',
                                style: bodyText16w600(color: yellow),
                              ),
                              addVerticalSpace(5),
                              Text(
                                '$courseDesc',
                                style: bodyText14normal(color: white),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              addVerticalSpace(5),
              premium == false
                  ? Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(8),
                      height: height(context) * 0.35,
                      width: width(context) * 0.95,
                      decoration: myFillBoxDecoration(
                          0, Colors.white.withOpacity(0.1), 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PremiumScreen()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: myFillBoxDecoration(0, yellow, 10),
                              height: 180,
                              width: width(context) * 0.9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: myFillBoxDecoration(
                                        0, Colors.black26, 40),
                                    child: Icon(Icons.lock_open_rounded),
                                  ),
                                  Text(
                                    'Unlock with premium',
                                    style: bodyText16w600(color: black),
                                  )
                                ],
                              ),
                            ),
                            addVerticalSpace(12),
                            Text(
                              'Above videos are sample ',
                              style: bodyText16w600(color: white),
                            ),
                            addVerticalSpace(5),
                            Text(
                              'You have to pay premium to watch this content.',
                              style: bodyText12Small(color: white),
                            ),
                            // i == 3
                            //     ? Container(
                            //         height: height(context) * 0.2,
                            //         width: width(context) * 0.9,
                            //         color: white,
                            //       )
                            //     : SizedBox()
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      widget.videoUrl,
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 180,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      VideoPlayer(_controller),
                      Positioned(
                        left: width(context) * 0.40,
                        top: height(context) * 0.075,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: myOutlineBoxDecoration(
                              1,
                              white,
                              50,
                            ),
                            child: Center(
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  closeVideo() {
    setState(() {
      _controller.pause();
    });
  }

  // Widget buildVideo() => VideoPlayer(_controller);
}
