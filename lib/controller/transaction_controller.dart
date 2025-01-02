import 'dart:convert';
import 'package:bill_payment/models/transaction.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController utrController = TextEditingController();
  final TextEditingController minAmountController = TextEditingController();
  final TextEditingController maxAmountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedTransactionType = "";
  final box = GetStorage();

  dynamic statusIcon;
  Color? statusColor;
  Color? statusBgColor;

  final ScrollController scrollController = ScrollController();
  List<Transaction> transactionLists = [];
  List<dynamic> transactionTypes = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = true;
  bool isError = false;

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);

    Map<String, dynamic> queryParams = {
      if (utrController.text.isNotEmpty) 'utr': utrController.text,
      if (minAmountController.text.isNotEmpty) 'min': minAmountController.text,
      if (maxAmountController.text.isNotEmpty) 'max': maxAmountController.text,
      if (dateController.text.isNotEmpty) 'created_at': dateController.text,
      if (selectedTransactionType!.isNotEmpty) 'type': selectedTransactionType!.toLowerCase(),
    };

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.transactionUri}?page=$currentPage';
      Uri uri;
      if (queryParams.isEmpty) {
        uri = Uri.parse(apiUrl);
      } else {
        uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
      }

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
        final List<dynamic> transactionData = data['message']['transactions']['data'];
        Set<String> uniqueTransactionTypes = <String>{};
        if (queryParams.isNotEmpty) {
          transactionLists = [];
        }

        transactionLists.addAll(transactionData.map((json) => Transaction.fromJson(json)));
        // transactionLists = transactionData.map((item) => Transaction.fromJson(item)).toList();

        currentPage = data['message']['transactions']['current_page'];
        lastPage = data['message']['transactions']['last_page'];

        for (var item in transactionData) {
          String type = item['type'];
          uniqueTransactionTypes.add(type);
        }
        transactionTypes = uniqueTransactionTypes.toList();

        isLoading = false;
        utrController.text = "";
        minAmountController.text = "";
        maxAmountController.text = "";
        dateController.text = "";
        selectedTransactionType = "";
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        isLoading = false;
        isError = true;
        update();
        if (kDebugMode) {
          print('Failed to load data. Status Code: ${response.statusCode}');
        }
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      isError = true;
      update();
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    } finally {
      isLoading = false;
      if (kDebugMode) {
        print('CURRENT PAGE: $currentPage \nLASTPAGE: $lastPage');
      }
    }
  }

  Future<void> loadMoreData() async {
    if (currentPage < lastPage) {
      currentPage++;
      await fetchData();
    }
  }
}
