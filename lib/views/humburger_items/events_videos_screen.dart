import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constant.dart';
import '../../widget/coming_soon_widget.dart';
import '../../widget/my_drawer.dart';
import '../../widget/video_player_widget.dart';

class EventsVideosScreen extends StatefulWidget {
  const EventsVideosScreen({super.key});

  @override
  State<EventsVideosScreen> createState() => _EventsVideosScreenState();
}

class _EventsVideosScreenState extends State<EventsVideosScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  List title = ['Award Function', 'Grand Event at Goa'];
  List<dynamic>? videosList = [];

  @override
  void initState() {
    getEventVideos();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldkey.currentState!.openDrawer();
            },
            icon: const ImageIcon(AssetImage('assets/images/main.png'))),
        title: Text(
          'Event Videos',
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
          // Center(
          //   child: Image.asset(
          //     "assets/images/coming-soon.png",
          //     width: width(context) * .8,
          //   ),
          // ),
          SizedBox(
            height: height(context) * 0.88,
            child: ListView.builder(
                itemCount: videosList!.length,
                // reverse: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  String videoUrl = videosList![i]['videoUrl'];
                  String videoTitle = videosList![i]['videoTitle'];
                  String videoDescription = videosList![i]['videoDescription'];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    padding: EdgeInsets.all(8),
                    // height: height(context) * 0.37,
                    width: width(context) * 0.9,
                    decoration: myFillBoxDecoration(
                        0, Colors.white.withOpacity(0.1), 15),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CmdMessageScreen()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 300,
                            width: width(context) * 0.9,
                            child: VideoPlayerScreen(videoUrl: videoUrl),
                          ),
                          addVerticalSpace(12),
                          Text(
                            videoTitle,
                            style: bodyText16w600(color: yellow),
                          ),
                          addVerticalSpace(3),
                          Row(
                            children: [
                              SizedBox(
                                width: width(context) * 0.75,
                                child: Text(
                                  videoDescription,
                                  style: bodyText13normal(color: white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void getEventVideos() async {
    var x =
        await FirebaseFirestore.instance.doc("eventsUpdates/EventVideos").get();

    print('[]]]]]]]]]]]]]]]]]]]]]]]]]]');
    print(x.data());
    videosList?.clear();

    List<dynamic>? list = x.data()?.values.toList();
    videosList = list!.reversed.toList();

    print('============================ $videosList');

    print(videosList);
    setState(() {});
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
            height: 300,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      VideoPlayer(_controller),
                      Align(
                        alignment: Alignment.center,
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


//https://assets.mixkit.co/videos/preview/mixkit-business-cycle-scheme-9406-large.mp4