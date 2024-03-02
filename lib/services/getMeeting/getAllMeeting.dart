import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/widget/custom_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

Widget getAllMeetings(BuildContext context) {
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();

  var height = MediaQuery.of(context).size.height;
  try {
    final _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Live')
          .where("isActive", isEqualTo: true)
          .snapshots()
          .handleError((error) {
        return Container(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
        );
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Widget> messageWidgets = snapshot.data!.docs.map<Widget>((m) {
          final data = m.data as dynamic;
          return InkWell(
            onTap: () async {
              //onTapAction
            },

            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              padding: EdgeInsets.all(8),
              // height: height(context) * 0.45,
              width: width(context) * 0.9,
              decoration:
                  myFillBoxDecoration(0, Colors.white.withOpacity(0.1), 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    width: width(context) * 0.9,
                    child: Image.network(data()["image"]),
                  ),
                  addVerticalSpace(12),
                  Text(
                    data()["title"],
                    style: bodyText16w600(color: yellow),
                  ),
                  addVerticalSpace(5),
                  Row(
                    children: [
                      SizedBox(
                        width: width(context) * 0.75,
                        child: Text(
                          data()["description"],
                          style: bodyText14normal(color: white),
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(10),
                  SizedBox(
                    height: 42,
                    child: CustomButton(
                        textWidget: Center(
                            child: Text(
                          'Join Now',
                          style: bodyText16w600(color: black),
                        )),
                        onTap: () async {
                          print("Launching meet link");
                          await launchUrl(Uri.parse(data()["url"]));
                        }),
                  )
                ],
              ),
            ),
            //addCardHere... data and m.id
          );
        }).toList();
        return Container(
          height: MediaQuery.of(context).size.height - 200,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: messageWidgets.length,
            cacheExtent: messageWidgets.length * 1000,
            itemBuilder: (context, index) {
              return messageWidgets[index];
            },
          ),
        );
      },
    );
  } catch (Ex) {
    print("0x1Error To Get User");
    return Container(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
