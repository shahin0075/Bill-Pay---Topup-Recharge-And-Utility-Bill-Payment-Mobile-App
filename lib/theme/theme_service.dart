import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final getStorage = GetStorage();
  final storageKey = "isDarkMode";
  final switchStateKey = "isSwitched";

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  // theme
  void saveThemeMode(bool isDarkMode) {
    getStorage.write(storageKey, isDarkMode);
  }

  // theme
  bool isSavedDarkMode() {
    return getStorage.read(storageKey) ?? false;
  }

  // cupertinoSwitch
  Future<void> saveThemeSwitchState(bool isSwitched) async {
    getStorage.write(switchStateKey, isSwitched);
  }

  // cupertinoSwitch
  bool getThemeSwitchState() {
    return getStorage.read(switchStateKey) ?? false;
  }

  // changing theme
  Future<void> changeTheme() async {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isSavedDarkMode());
  }
}
