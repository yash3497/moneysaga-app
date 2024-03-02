import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magnus_app/services/getMeeting/getAllMeeting.dart';
import 'package:magnus_app/widget/custom_button_widget.dart';

import '../../utils/constant.dart';
import '../../widget/coming_soon_widget.dart';
import '../../widget/my_drawer.dart';
import '../../widget/video_player_widget.dart';

class LiveMeetingsScreen extends StatelessWidget {
  const LiveMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldkey.currentState!.openDrawer();
            },
            icon: const ImageIcon(AssetImage('assets/images/main.png'))),
        title: Text(
          'Live Meetings',
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
          Center(
            child: Image.asset(
              "assets/images/coming-soon.png",
              width: width(context) * .8,
            ),
          ),
          // getAllMeetings(context),
        ],
      ),
    );
  }
}
