import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:magnus_app/utils/course.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constant.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/video_player_widget.dart';

class MyCourseScreen extends StatefulWidget {
  List<LectureContent> thisCourse = [];
  CourseContent course;
  String langugae;
  MyCourseScreen(this.thisCourse, this.course,
      {super.key, required this.langugae});

  @override
  State<MyCourseScreen> createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  @override
  void initState() {
    print(widget.thisCourse);
    print(widget.thisCourse);
    print('==========//////////===========');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: 'My Course ',
          subtitle: '${widget.langugae.toUpperCase()}',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(20),
            SizedBox(
              height: 180,
              width: width(context),
              child: VideoPlayerScreen(
                videoUrl: widget.course.url,
                mp: widget.course.toMap(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.title,
                    style: bodyText16w600(color: yellow),
                  ),
                  addVerticalSpace(7),
                  Text(
                    widget.course.description,
                    style: bodyText14normal(color: white),
                  ),
                  const Divider(
                    height: 30,
                    thickness: 2,
                  ),
                  Text(
                    'Next video',
                    style: bodyText16w600(color: yellow),
                  ),
                  addVerticalSpace(13),
                  ListView.builder(
                      itemCount: widget.thisCourse.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        int k = i + 1;
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(8),
                          // height: height(context) * 0.38,
                          width: width(context) * 0.95,
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
                                  child: widget.thisCourse[i].language ==
                                          widget.langugae
                                      ? widget.thisCourse[i].url != ""
                                          ? VideoPlayerScreen(
                                              videoUrl:
                                                  widget.thisCourse[i].url,
                                              mp: widget.thisCourse[i].toMap(),
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
                                  'Video $k : ${widget.thisCourse[i].title}',
                                  style: bodyText16w600(color: yellow),
                                ),
                                addVerticalSpace(5),
                                Text(
                                  widget.thisCourse[i].description,
                                  style: bodyText14normal(color: white),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// https://assets.mixkit.co/videos/preview/mixkit-man-in-a-suit-works-from-the-kitchen-4830-large.mp4

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
    log(mp.toString());
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
