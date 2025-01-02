import 'dart:convert';
import 'dart:io';
import 'package:bill_payment/models/two_factor_model.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bill_payment/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycController extends GetxController {
  Map<String, dynamic> kycData = {};
  Map<String, TextEditingController> textControllers = {};
  Map<String, File?> pickedFiles = {};
  TwoFactorModel? twoFactorInfo;
  String kycStatus = "";
  bool isLoading = false;
  bool isScreenLoading = false;
  String errorMessage = '';
  final box = GetStorage();

  // fetching two factor info
  Future<void> fetchKYCData() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isScreenLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.identityVerificationUri}';
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
        kycData = data['message']['kyc']['input_form'];
        kycStatus = data['message']['msg'];
        textControllers = {for (var key in kycData.keys) key: TextEditingController()};
        errorMessage = '';
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      errorMessage = 'Failed to load data!';
      isScreenLoading = false;
      update();
    } finally {
      isScreenLoading = false;
    }
  }

  // submit kyc
  Future<void> submitKYC() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.identityVerificationSubmissionUri}';

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add text field values to formData
      textControllers.forEach((fieldName, controller) {
        request.fields[fieldName] = controller.text;
      });

      // Add image files to formData
      pickedFiles.forEach((fieldName, file) async {
        if (file != null) {
          List<int> fileBytes = await file.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              fieldName,
              fileBytes,
              filename: file.path.split('/').last,
            ),
          );
        }
      });

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $authToken';

      // Send the request
      var response = await request.send();

      // Handle the response as needed
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
        String status = data['status'];
        String message = data['message'];
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        for (var controller in textControllers.values) {
          controller.clear();
        }
        pickedFiles.clear();
        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          "Failed",
          "Failed to submit KYC",
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print("Failed to submit KYC. Status code: ${response.statusCode}");
        }
        throw ("Failed to submit KYC");
      }
    } catch (e) {
      errorMessage = "Failed to submit KYC: $e";
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }
}
