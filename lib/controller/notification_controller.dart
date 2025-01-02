import 'dart:convert';
import 'package:bill_payment/models/notification_model.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  List<NotificationPermission> notificationPermissions = [];
  List<String> userActiveEmail = [];
  List<String> userActiveSms = [];
  List<String> userActivePush = [];
  List<String> userActiveInApp = [];
  bool isLoading = false;
  bool isScreenLoading = true;
  bool isError = false;
  String errorMessage = '';
  final box = GetStorage();

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);

    if (kDebugMode) {
      print("AUTHTOKEN: $authToken");
    }

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.notificationPermissionUri}';
      Uri uri = Uri.parse(apiUrl);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      // Check values from GetStorage
      dynamic storedEmail = box.read('isEmailVerified');
      dynamic storedSms = box.read('isSmsVerified');
      dynamic storedStatus = box.read('isStatusVerified');

      if (storedEmail != 1) {
        Get.offAllNamed(EmailVerification.routeName);
      } else if (storedSms != 1) {
        Get.offAllNamed(SmsVerification.routeName);
      } else if (storedStatus != 1) {
        Get.offAllNamed(SignInScreen.routeName);
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // template
        final List<dynamic> template = data['message']['allTemplates'];
        notificationPermissions = template.map((template) => NotificationPermission.fromJson(template)).toList();

        // stored active email permission
        List<dynamic> userActiveEmailData = data['message']['userActiveEmail'];
        userActiveEmail = List<String>.from(userActiveEmailData);

        // stored active smm permission
        List<dynamic> userActiveSmsData = data['message']['userActiveSms'];
        userActiveSms = List<String>.from(userActiveSmsData);

        // stored active push permission
        List<dynamic> userActivePushData = data['message']['userActivePush'];
        userActivePush = List<String>.from(userActivePushData);

        // stored active in app permission
        List<dynamic> userActiveInAppData = data['message']['userActiveInApp'];
        userActiveInApp = List<String>.from(userActiveInAppData);

        isScreenLoading = false;
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        isScreenLoading = false;
        isError = true;
        update();
        if (kDebugMode) {
          print('Failed to load data. Status Code: ${response.statusCode}');
        }
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      isScreenLoading = false;
      isError = true;
      update();
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    } finally {
      isScreenLoading = false;
    }
  }

  // send notification permission
  Future<void> sendDataToApi() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.notificationSubmitUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        body: {
          for (int i = 0; i < userActiveEmail.length; i++) 'email_key[$i]': userActiveEmail[i],
          for (int i = 0; i < userActiveSms.length; i++) 'sms_key[$i]': userActiveSms[i],
          for (int i = 0; i < userActivePush.length; i++) 'push_key[$i]': userActivePush[i],
          for (int i = 0; i < userActiveInApp.length; i++) 'in_app_key[$i]': userActiveInApp[i],
        },
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String status = data['status'];
        String message = data['message'];
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          'Failed',
          'Failed to change settings',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to change settings. Status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error posting data: $e');
      }
    } finally {
      isLoading = false;
    }
  }

  // capitalizes the first letter of each word
  String capitalizeEachWord(String input) {
    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }
}
