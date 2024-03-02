import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magnus_app/widget/custom_button_widget.dart';
import 'package:magnus_app/widget/custom_textformfield.dart';

import '../../utils/constant.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: myFillBoxDecoration(0, yellow, 30),
                        child: Icon(
                          Icons.arrow_back,
                          color: black,
                        )),
                  ),
                ],
              ),
              addVerticalSpace(20),
              Text(
                'Forgot your password?'.toUpperCase(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15),
                child: Image.asset('assets/images/forgotpass.png'),
              ),
              addVerticalSpace(height(context) * 0.05),
              Container(
                height: height(context) * 0.33,
                width: width(context) * 0.9,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                decoration: myFillBoxDecoration(0, Colors.white30, 10),
                child: Column(
                  children: [
                    const Text(
                      'Enter your registered email below to receive password reset instruction',
                      textAlign: TextAlign.center,
                    ),
                    addVerticalSpace(20),
                    SizedBox(
                      height: 55,
                      width: width(context) * 0.8,
                      child: CustomTextFormField(
                          error: "Enter Valid Email",
                          controller: _emailcontroller,
                          hintText: 'Enter Your Emamil Id',
                          keyBoardType: TextInputType.emailAddress),
                    ),
                    addVerticalSpace(height(context) * 0.07),
                    CustomButton(
                        textWidget: Center(
                          child: Text(
                            'Send reset link',
                            style: bodyText16w600(color: black),
                          ),
                        ),
                        onTap: () {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _emailcontroller.text)
                              .whenComplete(() {
                            Fluttertoast.showToast(
                                msg:
                                    'Password reset link sents on your email.');
                          });
                        })
                  ],
                ),
              ),
              addVerticalSpace(height(context) * 0.04),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Remember password? Login',
                  style: bodyText14w600(color: yellow),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
