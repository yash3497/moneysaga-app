import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/start/add_profiepic_screen.dart';
import 'package:magnus_app/widget/custom_textformfield.dart';

import '../../widget/custom_button_widget.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  TextEditingController dateinput = TextEditingController();
  
  @override
  void initState() {
    
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  final items = ['Choose Gender', 'Male', 'Female', 'Others'];
  String selectedValue = 'Choose Gender';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addVerticalSpace(height(context) * 0.18),
            Center(
              child: Container(
                child: Image.asset('assets/images/img1.png'),
              ),
            ),
            addVerticalSpace(height(context) * 0.05),
            Text(
              'Let’s Complete Your Profile',
              style: bodyText20w700(color: yellow),
            ),
            Text(
              'It will help us to know more about you!',
              style: bodyText12Small(color: white.withOpacity(0.7)),
            ),
            addVerticalSpace(height(context) * 0.04),
            Container(
              height: 50,
              width: width(context) * 0.88,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: myFillBoxDecoration(0, Colors.white12, 15),
              child: Center(
                child: DropdownButton<String>(
                  value: selectedValue,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
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
            addVerticalSpace(height(context) * 0.02),
            SizedBox(
              height: 50,
              width: width(context) * 0.9,
              child: CustomTextFormField(
                error: "Enter Valid Date",
                  controller: dateinput,
                  ontap: () async {
                    var pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1800),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);

                      setState(() {
                        dateinput.text = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  preffixIcon: Icon(Icons.calendar_month_outlined),
                  hintText: 'Date Of Birth',
                  keyBoardType: TextInputType.datetime),
            ),
            addVerticalSpace(height(context) * 0.06),
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
                  users.setGenderDOB(dateinput.text,selectedValue);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddProfilePic()));
                }),
          ],
        ),
      ),
    );
  }
}

Future<DateTime?> showDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
  TextInputType? keyboardType,
  Offset? anchorPoint,
}) async {
  assert(context != null);
  assert(initialDate != null);
  assert(firstDate != null);
  assert(lastDate != null);
  initialDate = DateUtils.dateOnly(initialDate);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);
  assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );
  assert(
    selectableDayPredicate == null || selectableDayPredicate(initialDate),
    'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.',
  );
  assert(initialEntryMode != null);
  assert(useRootNavigator != null);
  assert(initialDatePickerMode != null);
  assert(debugCheckHasMaterialLocalizations(context));

  Widget dialog = DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    initialCalendarMode: initialDatePickerMode,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
    keyboardType: keyboardType,
  );

  // if (textDirection != null) {
  //   dialog = Directionality(
  //     textDirection: textDirection,
  //     child: dialog,
  //   );
  // }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );
}
