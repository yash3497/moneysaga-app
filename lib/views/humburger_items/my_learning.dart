import 'dart:async';
// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magnus_app/utils/course.dart';
import 'package:magnus_app/utils/methods.dart';
import 'package:magnus_app/widget/my_drawer.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constant.dart';
import '../../widget/video_player_widget.dart';
import '../home/cmd_message_screen.dart';
import '../my_learning_tab/my_course_screen.dart';

late VideoPlayerController _controller;

class MyLearningScreen extends StatefulWidget {
  MyLearningScreen({super.key, required this.title});

  final String title;

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> {
  int currentIndex = 0;
  int currentLevelIndex = 0;
  List language = ['English', 'Hindi'];
  List level = ['Basic', 'Ad'];
  bool isChecked = true;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  List _list = [];
  List<CourseContent> l = [];
  List<CourseContent> list = [];
  List<LectureContent> listo = [];
  List<List<LectureContent>> completeLectureList = [];

  Timer? t;
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

  getFreeCourse() async {
    l.clear();
    var x = await FirebaseFirestore.instance
        .collection('freeCourses')
        .doc('v0w1gnT5nu8PWMXIKpIa')
        .get();
    int no = x.data()!.values.first;
    for (int i = 0; i < no; i++) {
      var j = await FirebaseFirestore.instance
          .collection('freeCourses')
          .doc('v0w1gnT5nu8PWMXIKpIa')
          .collection('courses${i + 1}')
          .doc('courseDetail')
          .get();
      CourseContent c = CourseContent.fromDocument(j);
      l.add(c);
      print(i);

      await getLectures(i);
      // t = Timer.periodic(Duration(seconds: 2), (_) => setState(() {}));
    }

    print("-----------------------------------------:" + l.length.toString());
    print(l);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getFreeCourse();
    listo.clear();
    // TODO: implement initState
    super.initState();
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
          'Free Courses',
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
      body: ListView.builder(
          itemCount: completeLectureList[0].length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            // Future<List> a = getLectures(i);

            // List<LectureContent> lis = abc(i);
            int k = i + 1;
            return Container(
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
              padding: EdgeInsets.all(10),
              // height: height(context) * 0.38,
              width: width(context) * 0.9,
              decoration:
                  myFillBoxDecoration(0, Colors.white.withOpacity(0.1), 15),
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
                      child: completeLectureList[0][i].language == "hindi"
                          ? completeLectureList[0][i].url != ""
                              ? VideoPlayerScreen(
                                  videoUrl: completeLectureList[0][i].url,
                                  mp: completeLectureList[0][i].toMap(),
                                )
                              : Center(
                                  child: Text(
                                    "This will be covered in online sessions",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                          : Center(
                              child: Text(
                              "Coming Soon",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )),
                    ),
                    addVerticalSpace(12),
                    Text(
                      'Video $k : ${completeLectureList[0][i].title}',
                      style: bodyText16w600(color: yellow),
                    ),
                    addVerticalSpace(5),
                    Text(
                      completeLectureList[0][i].description,
                      style: bodyText14normal(color: white),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  getCoursesData() async {
    var x = await FirebaseFirestore.instance
        .collection('freeCourses')
        .doc('v0w1gnT5nu8PWMXIKpIa')
        .get();
    int totalCourses = x.data()!['noOfCourses'];
    list.clear();
    for (int i = 0; i < totalCourses; i++) {
      int j = i + 1;
      var y = await FirebaseFirestore.instance
          .collection('freeCourses')
          .doc('v0w1gnT5nu8PWMXIKpIa')
          .collection('courses$j')
          .doc('courseDetail')
          .get();
      CourseContent c = CourseContent.fromDocument(y);
      list.add(c);
    }
    setState(() {});
  }

  // abc(int i) async {
  //   Future<List<LectureContent>> _futureOfList = getLectures(i);
  //   List<LectureContent> lio = await _futureOfList;
  //   return lio;
  //   print(list); // will print [1, 2, 3, 4] on console.
  // }

  getLectures(int x) async {
    // for (int k = 0; k < size; k++) {
    var j = await FirebaseFirestore.instance
        .collection('freeCourses')
        .doc('v0w1gnT5nu8PWMXIKpIa')
        .collection('courses${x + 1}')
        .doc('courseDetail')
        .collection('lectures')
        .get();
    List<LectureContent> lis = [];
    for (var element in j.docs) {
      lis.add(LectureContent.fromDocument(element));

      print("doc");
      print(element.id);
    }
    completeLectureList.add(lis);
  }
  // }
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
