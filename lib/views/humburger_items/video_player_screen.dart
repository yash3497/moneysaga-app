import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:video_player/video_player.dart';

class FullVideoPlayerScreen extends StatefulWidget {
  const FullVideoPlayerScreen(
      {super.key, required this.title, required this.controller});
  final String title;
  final VideoPlayerController controller;

  @override
  State<FullVideoPlayerScreen> createState() => _FullVideoPlayerScreenState();
}

class _FullVideoPlayerScreenState extends State<FullVideoPlayerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        VideoPlayer(widget.controller),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Duration? duration = await widget.controller.position;
                  widget.controller
                      .seekTo(Duration(seconds: duration!.inSeconds - 10));
                  setState(() {});
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
                      Icons.replay_10,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if (widget.controller.value.isPlaying) {
                      widget.controller.pause();
                    } else {
                      widget.controller.play();
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
                      widget.controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () async {
                  Duration? duration = await widget.controller.position;
                  widget.controller
                      .seekTo(Duration(seconds: duration!.inSeconds + 10));
                  setState(() {});
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
                      Icons.forward_10,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(
            top: 20,
            left: 10,
            child: BackButton(
              color: Colors.white,
            )),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${formatDuration(widget.controller.value.position.inSeconds)}',
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 10,
                width: width(context) * .65,
                child: LinearProgressIndicator(
                  value: widget.controller.value.position.inSeconds /
                      widget.controller.value.duration.inSeconds,
                  valueColor: AlwaysStoppedAnimation<Color>(yellow),
                  backgroundColor: Colors.grey.withOpacity(.5),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '${formatDuration(widget.controller.value.duration.inSeconds)}',
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

String formatDuration(int seconds) {
  Duration duration = Duration(seconds: seconds);
  String formattedDuration =
      "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

  return formattedDuration;
}
