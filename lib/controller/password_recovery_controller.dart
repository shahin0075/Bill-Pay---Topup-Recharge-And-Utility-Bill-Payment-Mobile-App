import 'dart:convert';

import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PasswordRecoveryController extends GetxController {
  int currentStep = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController validationCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  void nextStep() {
    currentStep++;
    update();
  }

  void previousStep() {
    currentStep--;
    update();
  }

  // send validation code
  Future<void> sendValidationCode() async {
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.getCodeUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailController.text}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      String status = data['status'];
      // String message = data['message'];

      if (response.statusCode == 200 && status.toLowerCase() == "success") {
        Get.snackbar(
          status,
          data['message']['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        nextStep();
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          status,
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to post data. Status code: ${response.statusCode}');
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

  // match validation code
  Future<void> matchValidationCode() async {
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.codeValidationUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailController.text, 'code': validationCodeController.text}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      String status = data['status'];
      // String message = data['message'];

      if (response.statusCode == 200 && status.toLowerCase() == "success") {
        Get.snackbar(
          status,
          data['message']['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        nextStep();
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          status,
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to post data. Status code: ${response.statusCode}');
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

  // resest the password
  Future<void> resetPassword() async {
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.resetPasswordUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
          'email': emailController.text,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      String status = data['status'];
      // String message = data['message'];

      if (response.statusCode == 200 && status.toLowerCase() == "success") {
        Get.snackbar(
          status,
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        Get.toNamed(SignInScreen.routeName);
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          status,
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to post data. Status code: ${response.statusCode}');
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
}
