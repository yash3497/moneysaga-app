import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:magnus_app/utils/course.dart';
import 'package:magnus_app/views/my_learning_tab/my_course_screen.dart';
import 'package:magnus_app/widget/my_drawer.dart';

import '../../utils/constant.dart';
import '../../widget/video_player_widget.dart';

class MyLearning extends StatefulWidget {
  const MyLearning({super.key});

  @override
  State<MyLearning> createState() => _MyLearningState();
}

class _MyLearningState extends State<MyLearning> {
  @override
  void initState() {
    getVideosPlayed();
    // TODO: implement initState
    super.initState();
  }

  // int currentIndex = 0;
  double perc = 0.0;
  bool loading = true;
  // List language = ['English', 'Hindi'];
  int currentLevelIndex = 0;
  List level = ['Basic', 'Advance'];

  int totalVideos = 0, completedVideos = 0;

  List<LectureContent> tempo = [];
  List<LectureContent> usersVideosWatched = [];
  CourseContent c = CourseContent(
      url: 'url',
      description: 'description',
      title: 'title',
      language: 'language',
      priceINR: '0',
      priceUSD: '0',
      level: 'level',
      totalLectures: 'totalLectures');

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        titleSpacing: 1,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              _globalKey.currentState!.openDrawer();
            },
            icon: const ImageIcon(AssetImage('assets/images/main.png'))),
        title: Text(
          'My Course : Total $totalVideos Videos',
          style: TextStyle(color: yellow, fontSize: 18),
        ),
        actions: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset("assets/images/LOG.png"),
          )
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: height(context) * 1.58,
          child: Column(
            children: [
              addVerticalSpace(20),
              Container(
                margin: EdgeInsets.only(
                  left: width(context) * 0.16,
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
                                // currentIndex = 0;
                                filterList();
                              });
                            },
                            child: Container(
                              height: height(context) * 0.04,
                              width: width(context) * 0.32,
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
              addVerticalSpace(5),
              Column(
                children: [
                  CustomLearningStatusWidget(
                      value: loading ? 0.0 : perc,
                      completeVid: '$completedVideos',
                      IncompleteVid: '${totalVideos - completedVideos}'),
                  Divider(
                    height: height(context) * 0.05,
                    thickness: 2,
                  ),
                  Container(
                      height: height(context),
                      width: width(context) * 0.95,
                      child: usersVideosWatched.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  addVerticalSpace(20),
                                  Image.asset(
                                      'assets/images/icons8-scorecard-100.png'),
                                  Text(
                                    "No Results Found",
                                    style: bodyText16w600(color: white),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: usersVideosWatched.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                int k = i + 1;
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyCourseScreen(
                                                  freeCourseDetails[0],
                                                  c,
                                                  langugae: 'hindi',
                                                )));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(8),
                                    height: height(context) * 0.38,
                                    width: width(context) * 0.95,
                                    decoration: myFillBoxDecoration(
                                        0, Colors.white.withOpacity(0.1), 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 180,
                                          child: VideoPlayerScreen(
                                            videoUrl: usersVideosWatched[i].url,
                                            mp: {},
                                          ),
                                        ),
                                        addVerticalSpace(12),
                                        Text(
                                          'Video $k : ${usersVideosWatched[i].title}',
                                          style: bodyText16w600(color: yellow),
                                        ),
                                        Text(
                                          usersVideosWatched[i].description,
                                          style: bodyText14normal(color: white),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getVideosPlayed() async {
    List list = users.videosWatched;
    print(list);
    tempo.clear();

    for (var element in list) {
      int idx = element.indexOf("_");
      String col = element.substring(0, idx).trim();
      String docu = element.substring(idx + 1).trim();
      String maini = col.startsWith('c')
          ? 'freeCourses/v0w1gnT5nu8PWMXIKpIa'
          : 'premiumCourses/2RPpH5VbPkwA1V5XoVxh';

      var y = await FirebaseFirestore.instance
          .doc('$maini/$col/courseDetail/lectures/$docu')
          .get();

      tempo.add(LectureContent.fromDocument(y));

      print(tempo[0].title);
      setState(() {});
    }
    filterList();
  }

  filterList() async {
    // var lang = currentLevelIndex == 0 ? 'english' : 'hindi';
    var lev = currentLevelIndex == 0 ? 'basic' : 'advance';
    usersVideosWatched.clear();

    tempo.forEach((element) {
      if (element.level == lev) {
        usersVideosWatched.add(element);
      }
    });

    getVidCount();
  }

  getVidCount() async {
    totalVideos = 0;
    completedVideos = 0;
    List l = [];
    for (var element in tempo) {
      if (!l.contains(element.courseName)) {
        l.add(element.courseName);
      }
    }
    print(l);

    for (var element in l) {
      String maini = element.startsWith('c')
          ? 'freeCourses/v0w1gnT5nu8PWMXIKpIa'
          : 'premiumCourses/2RPpH5VbPkwA1V5XoVxh';
      print('$maini/$element/');
      var y = await FirebaseFirestore.instance
          .doc('$maini/$element/courseDetail')
          .get();

      print(
          '[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');
      print(y.data());
      int vds = y.data()!['totalLectures'];
      totalVideos += vds;
    }
    print(totalVideos);
    completedVideos = usersVideosWatched.length;
    getPecent(completedVideos, totalVideos);
    setState(() {});
    // setState(() {
    //   loading = true;
    // });
  }

  getPecent(int completedVideos, int totalVideos) {
    setState(() {
      perc = 0.0;
    });
    double per = 0.0;
    if (completedVideos != 0 && totalVideos != 0)
      per = (completedVideos / totalVideos) * 100;
    setState(() {
      loading = false;
      perc = per.roundToDouble();
    });
  }
}

class CustomLearningStatusWidget extends StatefulWidget {
  CustomLearningStatusWidget(
      {required this.value,
      required this.completeVid,
      required this.IncompleteVid});

  double value;
  final String completeVid;
  final String IncompleteVid;

  @override
  State<CustomLearningStatusWidget> createState() =>
      _CustomLearningStatusWidgetState();
}

class _CustomLearningStatusWidgetState
    extends State<CustomLearningStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 0.23,
      width: width(context) * 0.87,
      padding: EdgeInsets.only(top: height(context) * 0.02),
      margin: EdgeInsets.only(top: height(context) * 0.03),
      decoration: myFillBoxDecoration(0, Colors.white.withOpacity(0.1), 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    widget.completeVid,
                    style: TextStyle(
                        fontSize: 28,
                        color: yellow,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Videos \nCompleted',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.IncompleteVid,
                    style: TextStyle(
                        fontSize: 28,
                        color: yellow,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Videos \nIncompleted',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text('${widget.value.toStringAsFixed(2)}%'),
              ),
              Slider(
                activeColor: yellow,
                // thumbColor: Colors.transparent,
                inactiveColor: Colors.grey,
                min: 0.0,
                max: 100.0,
                value: widget.value,
                onChanged: (value) {
                  setState(() {
                    // widget.value = value;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
