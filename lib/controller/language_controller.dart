import 'dart:convert';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  Map<String, dynamic> languageData = {};

  int? selectedLanguageIndex;

  @override
  void onInit() {
    super.onInit();
    selectedLanguageIndex = GetStorage().read<int>('languageIndex') ?? 1;
    fetchLanguageData(selectedLanguageIndex!);
  }

  Future<void> fetchLanguageData(int languageIndex) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.languageUri}$languageIndex';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final box = GetStorage();
        box.write('languageData', data['message']);

        if (kDebugMode) {
          print('Data stored successfully');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        if (kDebugMode) {
          print("Failed to fetch language");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching language: $e");
      }
    }
  }

  Map<String, dynamic> getStoredData() {
    final box = GetStorage();
    return box.read('languageData') ?? {};
  }
}
