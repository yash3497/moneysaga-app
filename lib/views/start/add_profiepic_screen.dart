import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/screen/overlaywidget.dart';
import 'package:magnus_app/views/start/premium_screen.dart';

import '../../widget/custom_button_widget.dart';

class AddProfilePic extends StatefulWidget {
  const AddProfilePic({super.key});

  @override
  State<AddProfilePic> createState() => _AddProfilePicState();
}

class _AddProfilePicState extends State<AddProfilePic> {
  File? file;
  String img = "";
  bool uploading = false;
  bool up = false;
  bool picked = false;

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
        imageQuality: 75);

    Reference ref = FirebaseStorage.instance.ref().child('profileImg');
    setState(() {
      uploading = true;
      picked = true;
    });
    Navigator.pop(context);
    // _showAlertDialog();
    Fluttertoast.showToast(msg: "Uploading Image..");
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        img = value;
      });
    });
    setState(() {
      uploading = false;
      up = true;
    });
    // Navigator.pop(context);
  }

  void cameraPickUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
        imageQuality: 75);

    setState(() {
      uploading = true;
      picked = true;
    });
    // _showAlertDialog();
    Fluttertoast.showToast(msg: "Uploading Image..");
    Reference ref = FirebaseStorage.instance.ref().child('profileImg');

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        img = value;
      });
    });
    setState(() {
      uploading = false;
      up = true;
    });
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    late ImageSource? imageSource;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    addVerticalSpace(height(context) * 0.04),
                    Text(
                      'Upload a Picture of Yourself',
                      style: bodyText20w700(color: yellow),
                    ),
                    addVerticalSpace(height(context) * 0.05),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet()));
                        setState(() {});
                      },
                      child: DottedBorder(
                        strokeWidth: 1,
                        strokeCap: StrokeCap.round,
                        dashPattern: [4, 3],
                        color: yellow,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(100),
                        padding: EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            height: 100,
                            width: 100,
                            // color: Colors.amber,
                            child: img == ''
                                ? Image.asset('assets/images/profilepic.png')
                                : Container(
                                    width: 100,
                                    height: 100,
                                    clipBehavior: Clip.hardEdge,
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Image.network(
                                      img,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.005),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet()));
                      },
                      child: Text(
                        'Upload an Image',
                        style: TextStyle(fontSize: 15, color: white),
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.5),
                    CustomButton(
                        textWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next ',
                              style: TextStyle(
                                  color: black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: black,
                              size: 20,
                            )
                          ],
                        ),
                        onTap: () {
                          if (up) {
                            users.setProfileImage(img);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PremiumScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Select an image first',
                                style: TextStyle(color: black),
                              ),
                              backgroundColor: white,
                            ));
                          }
                        }),
                    TextButton(
                        onPressed: () {
                          users.setProfileImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PremiumScreen()));
                        },
                        child: Text(
                          'Skip for now',
                          style: bodyText14w600(color: yellow),
                        ))
                  ],
                ),
              ),
              iconOverlay()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            // <-- SEE HERE
            title: const Text(
              'Selected Profile Picture',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            content: Container(
                height: height(context) * 0.5,
                child: Center(
                    child: img == ''
                        ? CircularProgressIndicator()
                        : Container(
                            height: height(context) * 0.3,
                            width: width(context) * 0.4,
                            child: Image.network(
                              img,
                              fit: BoxFit.fill,
                            )))),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          ),
        );
      },
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            'Choose Profile photo',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  cameraPickUploadImage();
                },
                child: Icon(Icons.camera),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                    cameraPickUploadImage();
                  },
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                width: 100,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickUploadImage();
                },
                child: Icon(Icons.image),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    pickUploadImage();
                  },
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
