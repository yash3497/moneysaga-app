import 'package:flutter/material.dart';
import 'package:magnus_app/utils/constant.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {required this.controller,
      required this.hintText,
      this.suffixText,
      this.preffixIcon,
      this.ontap,
      this.suffixicon,
      this.error,
      this.sub,
      this.com,
      this.inp,
      required this.keyBoardType});

  var sub;
  var inp;
  String? hintText, error;
  VoidCallback? ontap, com;
  Icon? suffixicon;
  Icon? preffixIcon;
  Widget? suffixText;
  TextInputType keyBoardType;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: ontap,
      keyboardType: keyBoardType,
      controller: controller,
      onFieldSubmitted: sub,
      onEditingComplete: com,
      textInputAction: inp,
      // validator: (value) => validate(),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: preffixIcon,
          border: const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixicon,
          suffix: suffixText,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 13),
          filled: true,

          // errorText: error,
          fillColor: Colors.white12,
          hintText: hintText),
    );
  }

  validate() {
    return true;
  }
}

class CustomTextFormButtonField extends StatelessWidget {
  CustomTextFormButtonField(
      {required this.controller,
      required this.hintText,
      this.suffixText,
      this.preffixIcon,
      this.ontap,
      this.suffixicon,
      this.error,
      this.sub,
      this.com,
      this.inp,
      this.obscureText,
      required this.keyBoardType});

  var sub;
  var inp;
  var obscureText;
  String? hintText, error;
  VoidCallback? ontap, com, chng;
  IconButton? suffixicon;
  Icon? preffixIcon;
  Widget? suffixText;
  TextInputType keyBoardType;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: ontap,
      keyboardType: keyBoardType,
      controller: controller,
      onFieldSubmitted: sub,
      onEditingComplete: com,
      onChanged: (value) => chng,
      textInputAction: inp,
      obscureText: obscureText,
      // validator: (value) => validate(),
      decoration: InputDecoration(
          prefixIcon: preffixIcon,
          border: const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixicon,
          suffix: suffixText,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 13),
          filled: true,

          // errorText: error,
          fillColor: Colors.white12,
          hintText: hintText),
    );
  }

  validate() {
    return true;
  }
}
