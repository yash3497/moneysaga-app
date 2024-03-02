import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/widget/custom_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

Widget getAllAwards(BuildContext context) {
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();

  var height = MediaQuery.of(context).size.height;
  try {
    final _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('awards')
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
          return Container(
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () async {
                //onTapAction
              },

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 180,
                      width: width(context) * 0.9,
                      child: Image.network(data()["image"])),
                  addVerticalSpace(12),
                  Text(
                    data()["awardTitle"],
                    style: bodyText16w600(color: yellow),
                  ),
                  addVerticalSpace(3),
                  Row(
                    children: [
                      SizedBox(
                        width: width(context) * 0.75,
                        child: Text(
                          data()["awardDescription"],
                          style: bodyText13normal(color: white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //addCardHere... data and m.id
            ),
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
