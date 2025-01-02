import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomColors {
  //Dark and Light Mode
  static Color getBodyColor() {
    return Get.isDarkMode ? bodyColorDark : bodyColor;
  }

  static Color getBodyColor2() {
    return Get.isDarkMode ? bodyColorDark : whiteColor;
  }

  static Color getContainerColor() {
    return Get.isDarkMode ? containerColorDark : whiteColor;
  }

  static Color getShadowColor() {
    return Get.isDarkMode ? shadowColorDark : shadowColor;
  }

  static Color getBorderColor() {
    return Get.isDarkMode ? borderColorDark : shadowColor;
  }

  static Color getTitleColor() {
    return Get.isDarkMode ? titleColorDark : titleColor;
  }

  static Color getTextColor() {
    return Get.isDarkMode ? textColorDark : textColor;
  }

  static Color getInputColor() {
    return Get.isDarkMode ? inputColorDark : bodyColor;
  }

  static Color getInputColor2() {
    return Get.isDarkMode ? inputColorDark : backgroundColor;
  }

  // Primary Colors
  static const Color whiteColor = Color(0xFFffffff);
  static Color primaryColor = const Color(0xFF84C874);
  static const Color secondaryColor = Color(0xFFFF536A);
  static const Color infoColor = Color(0xFF8fceff);
  static const Color violetColor = Color(0xFF9093fe);
  static const Color orangeColor = Color(0xFFff8254);
  static const Color warningColor = Color(0xFFffc457);

  // Backgorund Colors
  static const Color bodyColor = Color(0xFFf1f7f7);
  static const Color backgroundColor = Color(0xFFe7f1f2);
  static const Color primaryLight = Color(0xFFD8F7CE);
  static const Color primaryLight2 = Color(0xFFeeffe8);
  static const Color secondaryLight = Color(0xFFFFEDE6);
  static const Color infoLight = Color(0xFFd1e8ff);
  static const Color warningLight = Color(0xFFfff4e0);
  static const Color shadowColor = Color(0xFFeeeeee);
  static const Color scaffoldColor = Color(0xFF0b1727);

  // Text Colors
  static const Color titleColor = Color(0xFF383463);
  static const Color textColor = Color(0xFF5f7d95);

  // dark mode
  static const Color bodyColorDark = Color(0xFF0b1727);
  static const Color containerColorDark = Color(0xFF0e243c);
  static const Color shadowColorDark = Color(0x00000000);
  static const Color borderColorDark = Color(0xFF182E4E);
  static const Color titleColorDark = Color(0xFFf1f7f7);
  static const Color textColorDark = Color(0xFFD9E7FD);
  static const Color inputColorDark = Color(0xFF182E4E);

  static void updatePrimaryColor(String hexColor) {
    primaryColor = Color(int.parse(hexColor.replaceAll('#', '0xFF')));
  }
}
