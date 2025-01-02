import 'dart:convert';
import 'dart:ui';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  Future<void> fetchColors() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);

    String apiUrl = '${AppConstants.baseUri}${AppConstants.appConfigUri}';
    Uri uri = Uri.parse(apiUrl);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final String colorHex = jsonData['message']['appColor'];
      // Update the primaryColor with the color from the API response
      CustomColors.primaryColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } else {
      if (kDebugMode) {
        print("Failed to load colors from API");
      }
      throw Exception('Failed to load colors from API');
    }
  }
}
