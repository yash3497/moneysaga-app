import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constant.dart';
import '../../utils/userModel.dart';
import '../../widget/my_drawer.dart';
import '../start/log_in_screen.dart';

late VideoPlayerController controller;

class CmdMessageScreen extends StatefulWidget {
  const CmdMessageScreen({super.key});

  @override
  State<CmdMessageScreen> createState() => _CmdMessageScreenState();
}

String url = "";
String title = "";
String name = "";
String profession = "";
String discription = "";

class _CmdMessageScreenState extends State<CmdMessageScreen> {
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
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>CmdMessageScreen()));
  }

  void isPremium() async {
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser!.uid);
      var x = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      x.get().then((value) async {
        print(value.data());
        if (value.data() != null) {
          print(value.data());
          users = Users.fromDocument(value);
          setState(() {});
        } else {
          MaterialPageRoute(builder: (context) => LogInScreen());
          FirebaseAuth.instance.signOut();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    isPremium();
    print(users.toMap());
    // TODO: implement initState
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
              // controller.pause();
              _scaffoldkey.currentState!.openDrawer();
              setState(() {});
            },
            icon: ImageIcon(AssetImage('assets/images/main.png'))),
        toolbarHeight: 60,
        elevation: 0,
        title: Text(
          'Message From CEO',
          style: TextStyle(color: yellow, fontSize: 18),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: width(context),
              child: Image.network(url),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name",
                    style: bodyText20w700(color: white),
                  ),
                  Text(
                    '$profession',
                    style: TextStyle(color: yellow),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  // Text(
                  //   '$title',
                  //   style: bodyText16w600(color: yellow),
                  // ),
                  addVerticalSpace(10),
                  Text(
                    '$discription',
                    style: bodyText14normal(color: white),
                  ),
                ],
              ),
            )
          ],
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
  // late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    isPremium();
    controller = VideoPlayerController.network(
      widget.videoUrl,
    );

    _initializeVideoPlayerFuture = controller.initialize();

    controller.setLooping(true);
  }

  @override
  void dispose() {
    // controller.pause();
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
          print(users.toMap());
          print(users.isPremium);
          setState(() {});
        } else {
          MaterialPageRoute(builder: (context) => LogInScreen());
          FirebaseAuth.instance.signOut();
        }
      });
    }
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
                      VideoPlayer(controller),
                      Positioned(
                        left: width(context) * 0.40,
                        top: height(context) * 0.075,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
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
                                controller.value.isPlaying
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
      controller.pause();
    });
  }

  // Widget buildVideo() => VideoPlayer(_controller);
}
