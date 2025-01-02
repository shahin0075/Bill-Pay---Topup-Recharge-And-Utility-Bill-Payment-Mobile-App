import 'dart:convert';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  final box = GetStorage();

  // sign in
  Future<void> signIn(String username, String password) async {
    isLoading = true;
    update();

    try {
      // Define your API URL
      String apiUrl = '${AppConstants.baseUri}${AppConstants.loginUri}';

      // Create a Uri object with the API URL and query parameters
      Uri uri = Uri.parse(apiUrl);

      // Make an HTTP GET request with the constructed URL
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = jsonDecode(response.body);
      String status = data['status'];
      String message = data['message'];

      if (response.statusCode == 200) {
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        final String token = data['token'];
        await _saveTokenToPrefs(token);

        // Get.offAllNamed(BottomNavBar.routeName);
        fetchUserData();

        isLoading = false;
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        isLoading = false;
        if (kDebugMode) {
          print('Failed to sign in. Status code: ${response.statusCode}');
        }
        update();
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // sign up
  Future<void> signUp(String name, String username, String email, String phoneCode, String phone, String password,
      String confirmPassword) async {
    isLoading = true;
    update();

    try {
      // Define your API URL
      String apiUrl = '${AppConstants.baseUri}${AppConstants.registerUri}';

      // Create a Uri object with the API URL and query parameters
      Uri uri = Uri.parse(apiUrl);

      // Make an HTTP GET request with the constructed URL
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'phone_code': phoneCode,
          'phone': phone,
          'password': password,
          'password_confirmation': confirmPassword,
          'sponsor': "",
        }),
      );

      final data = jsonDecode(response.body);
      String status = data['status'];
      String message = data['message'];
      if (response.statusCode == 200) {
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        final String token = data['token'];
        await _saveTokenToPrefs(token);

        fetchUserData();

        isLoading = false;
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        isLoading = false;
        if (kDebugMode) {
          print('Failed to sign up. Status code: ${response.statusCode}');
        }
        update();
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);

    String apiUrl = '${AppConstants.baseUri}${AppConstants.userDataUri}';
    Uri uri = Uri.parse(apiUrl);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final dynamic email = jsonData['message']['email_verification'];
      final dynamic sms = jsonData['message']['sms_verification'];
      final dynamic status = jsonData['message']['status'];

      box.write('isEmailVerified', email);
      box.write('isSmsVerified', sms);
      box.write('isStatusVerified', status);

      // Check values from GetStorage
      dynamic storedEmail = box.read('isEmailVerified');
      dynamic storedSms = box.read('isSmsVerified');
      dynamic storedStatus = box.read('isStatusVerified');

      if (kDebugMode) {
        print("storedEmail ----->: $storedEmail, storedSms ----->: $storedSms, storedStatus ----->: $storedStatus");
      }

      if (storedEmail != 1) {
        Get.offAllNamed(EmailVerification.routeName);
      } else if (storedSms != 1) {
        Get.offAllNamed(SmsVerification.routeName);
      } else if (storedStatus != 1) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.offAllNamed(BottomNavBar.routeName);
      }
    } else {
      if (kDebugMode) {
        print("Failed to load colors from API");
      }
      throw Exception('Failed to load colors from API');
    }
  }

  // email verification
  Future<void> emailVerification(dynamic code) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    // Replace the Map below with your request data
    final Map<String, dynamic> postData = {'code': code};
    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.emailVerifyUri}';
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
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        Get.offAllNamed(BottomNavBar.routeName);
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          'Failed',
          'Failed to change password',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to verify code. Status code: ${response.statusCode}');
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

  // sms verification
  Future<void> smsVerification(dynamic code) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    // Replace the Map below with your request data
    final Map<String, dynamic> postData = {'code': code};
    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.smsVerifyUri}';
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
        Get.snackbar(
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        Get.offAllNamed(BottomNavBar.routeName);
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          'Failed',
          'Failed to change password',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to verify code. Status code: ${response.statusCode}');
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

  // resend verification code
  Future<void> resendCode(String type) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.resendCodeUri}?type=$type';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
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
          'Failed to resend code',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to resend code. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetchinig data: $e');
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.token, token);
  }

  Future<String?> getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.token);
  }

  // Method to clear the token from shared preferences
  Future<void> _clearTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.token);
  }

  // Method to clear the token and navigate to the sign-in screen
  Future<void> logout() async {
    await _clearTokenFromPrefs();
    Get.offAllNamed(SignInScreen.routeName); // Replace with your sign-in screen route
  }
}
