import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFb764);
const Color pinkClr = Color(0xFFff4667);
const Color whiteClr = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: primaryClr,
      brightness: Brightness.light
  );

  static final dark = ThemeData(
      backgroundColor: darkGreyClr,
      primaryColor: darkGreyClr,
      brightness: Brightness.dark
  );
}
TextStyle get subHeadingStyle {
  return (
        TextStyle(
        color: Colors.grey,
        fontSize: 20,
        fontWeight: FontWeight.bold,
  )
  );
}


TextStyle get headingStyle {
  return (
        TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      )
  );
}
TextStyle get titleStyle {
  return (
        TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}
TextStyle get subTitleStyle {
  return (
        TextStyle(
        fontSize: 15,
        color: Get.isDarkMode? Colors.white: Colors.black,
        fontWeight: FontWeight.w400,
      )
  );
}