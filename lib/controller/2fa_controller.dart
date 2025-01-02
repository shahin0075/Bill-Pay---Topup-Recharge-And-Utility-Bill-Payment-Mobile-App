import 'dart:convert';
import 'package:bill_payment/models/two_factor_model.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bill_payment/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TwoFaController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController authenticationCodeController = TextEditingController();
  String? textToCopy;
  TwoFactorModel? twoFactorInfo;
  bool isLoading = true;
  String errorMessage = '';
  final box = GetStorage();

  // fetching two factor info
  Future<void> fetchTwoFactorInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.twoFaUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
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
        final Map<String, dynamic> data = jsonDecode(response.body);
        twoFactorInfo = TwoFactorModel.fromJson(data['message']);
        errorMessage = '';
        textToCopy = twoFactorInfo!.secret;
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        throw Exception('Result Not Found!');
      }
    } catch (e) {
      errorMessage = 'Result Not Found!';
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // enable two factor authentication
  Future<void> enableTwoFactor(dynamic key) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    // Replace the Map below with your request data
    final Map<String, dynamic> postData = {
      'code': authenticationCodeController.text,
      'key': key,
    };
    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.enableTwoFaUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        body: jsonEncode(postData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String status = data['status'];
        String message = data['message'];
        errorMessage = '';
        authenticationCodeController.text = "";
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
          "Failed",
          "Couldn't enable two factor authentication",
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print("Couldn't enable two factor authentication");
        }
      }
    } catch (e) {
      errorMessage = "Couldn't enable two factor authentication";
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // disable two factor authentication
  Future<void> disableTwoFactor(dynamic key) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    // Replace the Map below with your request data
    final Map<String, dynamic> postData = {
      'code': authenticationCodeController.text,
      'key': key,
    };

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.disableTwoFaUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        body: jsonEncode(postData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String status = data['status'];
        String message = data['message'];
        errorMessage = '';
        authenticationCodeController.text = "";
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
          "Failed",
          "Couldn't disable two factor authentication",
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print("Couldn't disable two factor authentication");
        }
      }
    } catch (e) {
      errorMessage = "Couldn't disable two factor authentication";
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  Future<void> copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: twoFactorInfo!.secret));
    Get.snackbar(
      "Copied",
      "Copied: $textToCopy",
      duration: const Duration(seconds: 2),
      backgroundColor: CustomColors.getContainerColor(),
    );
  }

  void openStore() async {
    final Uri appStoreUrl = Uri.parse(twoFactorInfo!.downloadAppIOS);
    final Uri playStoreUrl = Uri.parse(twoFactorInfo!.downloadApp);

    if (await canLaunchUrl(appStoreUrl)) {
      await launchUrl(appStoreUrl);
    } else if (await canLaunchUrl(playStoreUrl)) {
      await launchUrl(playStoreUrl);
    } else {
      Get.snackbar(
        "Failed",
        "Couldn't launch to the store.",
        duration: const Duration(seconds: 2),
        backgroundColor: CustomColors.getContainerColor(),
      );
      throw "Couldn't launch to the store.";
    }
  }
}
