import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magnus_app/widget/coming_soon_widget.dart';

import '../../utils/constant.dart';
import '../../widget/my_drawer.dart';
import '../../widget/video_player_widget.dart';

class EventsAndAwardsPhotoWidget extends StatefulWidget {
  EventsAndAwardsPhotoWidget(
      {required this.listEventsandAwards, required this.title});

  List listEventsandAwards;
  String title;

  @override
  State<EventsAndAwardsPhotoWidget> createState() =>
      _EventsAndAwardsPhotoWidgetState();
}

class _EventsAndAwardsPhotoWidgetState
    extends State<EventsAndAwardsPhotoWidget> {
  @override
  void initState() {
    getEventPhotoData();
    // TODO: implement initState
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  List<dynamic>? photoList = [];

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
          widget.title,
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
                itemCount: photoList!.length,
                // reverse: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
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
                              height: height(context) * .25,
                              width: width(context) * 0.9,
                              child: Image.network(
                                photoList![i]['photoUrl'],
                                fit: BoxFit.cover,
                              )),
                          addVerticalSpace(12),
                          Text(
                            photoList![i]['photoTitle'],
                            style: bodyText16w600(color: yellow),
                          ),
                          // addVerticalSpace(3),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: width(context) * 0.75,
                          //       child: Text(
                          //         photoList![i]['photoDescription'],
                          //         style: bodyText13normal(color: white),
                          //       ),
                          //     ),
                          //   ],
                          // )
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

  void getEventPhotoData() async {
    var x =
        await FirebaseFirestore.instance.doc("eventsUpdates/EventPhotos").get();

    print('[]]]]]]]]]]]]]]]]]]]]]]]]]]');
    print(x.data());
    photoList?.clear();

    List<dynamic>? list = x.data()?.values.toList();
    photoList = list!.reversed.toList();
    print('============================ $photoList');

    print(photoList);
    setState(() {});
  }
}

//https://assets.mixkit.co/videos/preview/mixkit-business-cycle-scheme-9406-large.mp4