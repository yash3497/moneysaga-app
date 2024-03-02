import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magnus_app/widget/custom_button_widget.dart';
import 'package:magnus_app/widget/custom_textformfield.dart';
import 'package:magnus_app/widget/my_drawer.dart';

import '../../utils/constant.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController mobile = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController dob = TextEditingController();

  final items = ['Choose Gender', 'Male', 'Female', 'Others'];

  String? selectedValue = 'Choose Gender';
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: black.withOpacity(0.1),
        leading: IconButton(
            onPressed: () {
              _globalKey.currentState!.openDrawer();
            },
            icon: const ImageIcon(AssetImage('assets/images/main.png'))),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/myprofile.png'),
              ),
              addVerticalSpace(10),
              Text(
                'Change photo',
                style: TextStyle(color: yellow),
              ),
              addVerticalSpace(15),
              Container(
                margin: EdgeInsets.only(top: 15),
                height: 50,
                width: width(context) * 0.9,
                child: CustomTextFormField(
error: "Enter Valid Name",
                    preffixIcon: Icon(Icons.person_outline),
                    controller: nameController,
                    hintText: users.fullName,
                    keyBoardType: TextInputType.name),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                height: 50,
                width: width(context) * 0.9,
                child: CustomTextFormField(
                  error: "Enter Valid Number",
                    preffixIcon: Icon(Icons.call_outlined),
                    controller: mobile,
                    hintText: users.mobNum,
                    keyBoardType: TextInputType.number),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                height: 50,
                width: width(context) * 0.9,
                child: CustomTextFormField(
                  error:"enter valid email",
                    preffixIcon: Icon(Icons.email_outlined),
                    controller: email,
                    hintText: users.email,
                    keyBoardType: TextInputType.emailAddress),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                height: 50,
                width: width(context) * 0.9,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: myFillBoxDecoration(0, Colors.white12, 15),
                child: Center(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    items: items
                        .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                        .toList(),

                    // add extra sugar..
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                    iconSize: 30,
                    underline: const SizedBox(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                height: 50,
                width: width(context) * 0.9,
                child: CustomTextFormField(
                  error: "Enter Valid Date of Birth",
                    preffixIcon: Icon(Icons.calendar_month_outlined),
                    controller: dob,
                    hintText: users.dob,
                    keyBoardType: TextInputType.name),
              ),
              addVerticalSpace(height(context) * 0.22),
              CustomButton(
                  textWidget: Center(
                    child: Text(
                      'Save details',
                      style: bodyText16w600(color: black),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
