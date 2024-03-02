import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magnus_app/utils/methods.dart';
import 'package:magnus_app/views/humburger_items/video_player_screen.dart';
import 'package:magnus_app/views/start/premium_screen.dart';
import 'package:magnus_app/widget/my_drawer.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constant.dart';
import '../../utils/course.dart';
import '../../widget/video_player_widget.dart';
import '../home/cmd_message_screen.dart';
import '../my_learning_tab/my_course_screen.dart';

late VideoPlayerController _controller;

class MyPremiumLearningScreen extends StatefulWidget {
  MyPremiumLearningScreen({super.key, required this.level});

  final String level;

  @override
  State<MyPremiumLearningScreen> createState() =>
      _MyPremiumLearningScreenState();
}

class _MyPremiumLearningScreenState extends State<MyPremiumLearningScreen> {
  List<CourseContent> tempo = [];
  List<CourseContent> usersVideosWatched = [];

  int currentLangIndex = 0;
  int currentLevelIndex = 0;
  List language = ['Forex', 'Stock Market'];
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  bool isChecked = true;
  List _list = [];
  List<LectureContent> lectures = [];
  getDocumentData() async {
    //_list.clear();
    var collection = FirebaseFirestore.instance
        .collection('freeCourses')
        .doc("v0w1gnT5nu8PWMXIKpIa")
        .collection("course1");
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      _list.add(data);
      // _list.clear();
    }
    if (mounted) {
      setState(() {});
    }
  }

  _fetchLectures() async {
    lectures.clear();
    setState(() {});
    await FirebaseFirestore.instance
        .collection("premiumCourses")
        .doc("2RPpH5VbPkwA1V5XoVxh")
        .collection(currentLangIndex == 0 ? "pCourse1" : "pCourse2")
        .doc('courseDetail')
        .collection('lectures')
        .where("level", isEqualTo: widget.level)
        .where("language", isEqualTo: "hindi")
        .get()
        .then((value) {
      setState(() {
        lectures =
            value.docs.map((e) => LectureContent.fromDocument(e)).toList();
        lectures.sort(
          (a, b) => int.parse(a.rank).compareTo(int.parse(b.rank)),
        );
      });
    });
  }

  @override
  void initState() {
    getVideosPlayed();
    // TODO: implement initState
    super.initState();
    _fetchLectures();
  }

  @override
  Widget build(BuildContext context) {
    // getDocumentData();
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldkey.currentState!.openDrawer();
            },
            icon: const ImageIcon(AssetImage('assets/images/main.png'))),
        title: Text(
          '${widget.level.toUpperCase()} LEARNING',
          style: TextStyle(color: yellow),
        ),
        actions: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset("assets/images/LOG.png"),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 15,
              bottom: 8,
              // left: width(context) * 0.16,
            ),
            height: height(context) * 0.04,
            width: width(context) * 0.8,
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
                          });
                          _fetchLectures();
                          filterList();
                        },
                        child: Container(
                          height: height(context) * 0.04,
                          width: width(context) * 0.35,
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
          users.isPremium
              ? Flexible(
                  child: ListView.builder(
                      itemCount: lectures.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        int k = i + 1;
                        return Container(
                          margin: EdgeInsets.only(
                              bottom: 10, top: 10, left: 10, right: 10),
                          padding: EdgeInsets.all(8),
                          height: height(context) * 0.38,
                          width: width(context) * 0.9,
                          decoration: myFillBoxDecoration(
                              0, Colors.white.withOpacity(0.1), 15),
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             HomeCourseVideoPlay()));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 180,
                                    width: width(context) * 0.9,
                                    child: lectures[i].url != ""
                                        ? VideoPlayerScreen(
                                            videoUrl: lectures[i].url,
                                            mp: lectures[i].toMap(),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: black,
                                            child: Center(
                                              child: Text(
                                                currentLangIndex == 0
                                                    ? "Coming Soon"
                                                    : "This will be covered in online sessions",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          )),
                                addVerticalSpace(12),
                                Text(
                                  'Video $k : ${lectures[i].title}',
                                  style: bodyText16w600(color: yellow),
                                ),
                                addVerticalSpace(5),
                                Text(
                                  lectures[i].description,
                                  style: bodyText14normal(color: white),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(8),
                  height: height(context) * 0.35,
                  width: width(context) * 0.95,
                  decoration:
                      myFillBoxDecoration(0, Colors.white.withOpacity(0.1), 15),
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
                                decoration:
                                    myFillBoxDecoration(0, Colors.black26, 40),
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
        ],
      ),
    );
  }

  Future<void> getVideosPlayed() async {
    List list = users.purchasedCourses;
    tempo.clear();

    for (var element in list) {
      var y = await FirebaseFirestore.instance
          .doc('premiumCourses/2RPpH5VbPkwA1V5XoVxh/$element/courseDetail')
          .get();
      tempo.add(CourseContent.fromDocument(y));

      setState(() {});
    }
    filterList();
  }

  filterList() async {
    var lang = currentLangIndex == 0 ? 'english' : 'hindi';
    var lev = widget.level == 0 ? 'basic' : 'advance';
    usersVideosWatched.clear();

    tempo.forEach((element) {
      print(element.level);
      if (element.language == lang && element.level == widget.level) {
        usersVideosWatched.add(element);
      }
    });
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({required this.videoUrl, required this.mp});

  final String videoUrl;
  final Map<String, dynamic> mp;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
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
                            addToDb(widget.mp);

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
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullVideoPlayerScreen(
                                      title: '', controller: _controller),
                                ));
                          },
                          child: Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  void addToDb(Map<String, dynamic> mp) async {
    print('==========================');
    if (mp['courseName'] != null && mp['docName'] != null) {
      String s = '${mp['courseName']}_${mp['docName']}';
      List l = [];
      l.clear();
      l.add(s);
      var x = await FirebaseFirestore.instance
          .collection('users')
          .doc(users.uid)
          .update({
        'videosWatched': FieldValue.arrayUnion(l),
        'freeCourses': FieldValue.arrayUnion([mp['courseName']]),
      }).then((value) => print('added'));
    }
  }

  // Widget buildVideo() => VideoPlayer(_controller);
}
