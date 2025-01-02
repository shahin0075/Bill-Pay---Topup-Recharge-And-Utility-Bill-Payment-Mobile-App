import 'dart:convert';
import 'package:bill_payment/controller/payment_controller.dart';
import 'package:bill_payment/models/billing_category.dart';
import 'package:bill_payment/models/payment_method.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/bill/bill_request_screen.dart';
import 'package:bill_payment/screens/bill/billpay_screen.dart';
import 'package:bill_payment/screens/bill/pay_list_screen.dart';
import 'package:bill_payment/screens/bill/payment_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:bill_payment/widgets/custom_alert_dialog.dart';
import 'package:bill_payment/widgets/web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BillPayController extends GetxController {
  List<BillingCategory>? billingCategories;
  List<BillingService> billingServices = [];
  List<BillingService> selectableServices = [];
  List<dynamic> countries = [];
  List<dynamic> extraResponses = [];
  List<dynamic> labelList = [];
  final box = GetStorage();

  Map<String, TextEditingController> textControllers = {};
  Map<String, TextEditingController> manualPaymentParameters = {};
  final TextEditingController amountController = TextEditingController();

  BillingService? selectedService;
  String? selectedCountry;
  String? selectedServiceType;
  String? selectedCountryCode;
  String? selectedExtraResponse;

  Gateway? selectedGateway;

  // card info
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  // payment preview
  List<Gateway> filteredGateways = [];
  BillPreview? paymentPreview;
  dynamic utr;

  // getting payment controller
  late SdkPaymentHandle paymentController;

  @override
  void onInit() {
    super.onInit();
    paymentController = Get.find<SdkPaymentHandle>();
  }

  // New gateway data to insert
  Gateway walletPayment = Gateway(
    id: 00,
    image: "path/to/image.jpg",
    driver: "local",
    name: "wallet",
    minAmount: "0.00",
    maxAmount: "0.00",
    percentageCharge: "0.00",
    fixedCharge: "0.00",
    conventionRate: "0.00",
    sortBy: 0, // You can adjust the sort_by value according to your requirements
    parameters: {
      "param_key": "param_value",
      // ... other parameters
    },
    imagePath: "https://img.freepik.com/psd-gratis/monedero-digital-3d-nft-icon_629802-10.jpg",
  );

  bool isLoading = false;
  bool isScreenLoading = true;
  String errorMessage = '';

  // calculate payable amount
  double? totalPayableAmount;
  void calculatePayableAmount(double amount, double charge, double rate, double fixedCharge, double percentageCharge) {
    var total = ((1 / rate) * (amount + charge));
    var pCharge = (total / 100) * percentageCharge;
    totalPayableAmount = total + pCharge + fixedCharge;
  }

  // fetch bill categories
  Future<void> fetchBillingCategories() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.billCategoryUri}';
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
        final Map<String, dynamic> activeServices = data['message']['activeServices'];

        // inserting category images for mobile view staticly
        // activeServices.forEach((key, value) {
        //   if (newImages.isNotEmpty) {
        //     value["newImage"] = newImages.removeAt(0);
        //   }
        // });
        billingCategories = activeServices.entries.map((entry) => BillingCategory.fromJson(entry.value)).toList();

        errorMessage = '';
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

  // fetching two factor info
  Future<void> fetchBillForm(dynamic key) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isScreenLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.billFormUri}$key';
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
        Set<String> uniqueCountries = <String>{};

        final servicesList = data['message']['services'] as List<dynamic>;
        billingServices = servicesList.map((service) => BillingService.fromJson(service)).toList();

        for (var item in servicesList) {
          String country = item['countryName'];
          uniqueCountries.add(country);
        }
        countries = uniqueCountries.toList();

        errorMessage = '';
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      errorMessage = 'Failed to load data!';
      if (kDebugMode) {
        print('Failed to load fill form');
      }
      isScreenLoading = false;
      update();
    } finally {
      isScreenLoading = false;
    }
  }

  // filter services by country name
  void filterServicesByCountry(String country) async {
    selectableServices = billingServices.where((service) => service.countryName == country).toList();
    selectedCountry = country;
    selectedCountryCode = selectableServices[0].country;
    update();
  }

  // find service using id
  void findServiceById(dynamic id) {
    selectedService = selectableServices.firstWhere((service) => service.id.toString() == id);
    update();
  }

  // get extra_response from selectedService
  void fetchExtraResponse() {
    labelList = List.from(selectedService!.labelName);
    for (String fieldName in labelList) {
      textControllers[fieldName] = TextEditingController();
    }
    extraResponses = List.from(selectedService!.extraResponse);
    update();
  }

  // get gateway params from selectedService
  void storeGatewayParameters() {
    if (selectedGateway != null) {
      for (var fieldName in selectedGateway!.parameters.entries) {
        manualPaymentParameters[fieldName.key] = TextEditingController();
      }
      update();
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

  // billing information
  Future<void> submitBillingInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.billFormSubmitUri}';
      Map<String, String> request = {};

      // Extract text from additional controllers and add to the request data
      request['service'] = selectedService!.id.toString();
      request['country'] = selectedCountryCode!;
      request['amount'] = selectedExtraResponse ?? amountController.text;

      // Add text field values to formData
      textControllers.forEach((fieldName, controller) {
        request[fieldName] = controller.text;
      });

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        if (data['status'].toLowerCase() == "success") {
          Get.toNamed(PaymentScreen.routeName); // navigate to the payment screen
          utr = data['message']['utr']; // saved utr to fetch payment preview data

          for (var controller in textControllers.values) {
            controller.clear();
          }
        } else {
          Get.snackbar(
            data['status'],
            data['message'],
            duration: const Duration(seconds: 2),
            backgroundColor: CustomColors.getContainerColor(),
          );
        }

        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print('Failed to send data. Status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
        throw ("Failed to send data");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to send data: $e");
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // getting payment options and bill preview data
  Future<void> fetchPaymentMethods(dynamic utr) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isScreenLoading = true;
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.billPreviewUri}$utr';
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
        paymentPreview = BillPreview.fromJson(data['message']);
        paymentPreview!.gateways.insert(0, walletPayment); // inserting wallet payment manually

        filteredGateways = paymentPreview!.gateways;

        // saving billPayId for sdk payment handle
        paymentController.billPayId = paymentPreview!.id.toString();

        for (var gateway in paymentPreview!.gateways) {
          //Stripe
          if (gateway.name.toLowerCase() == "stripe" || gateway.id == 2) {
            paymentController.stripeSecretKey = gateway.parameters!['secret_key'];
            paymentController.stripePublisherKey = gateway.parameters!['publishable_key'];
          }

          //RazorPay
          if (gateway.name.toLowerCase() == "razorpay") {
            paymentController.keyIdRazorPay = gateway.parameters!['key_id'];
            paymentController.keySecretRazorPay = gateway.parameters!['key_secret'];
          }

          //Paytm
          if (gateway.name.toLowerCase() == "paytm") {
            paymentController.midPaytm = gateway.parameters!['MID'];
            paymentController.merchantKeyPaytm = gateway.parameters!['merchant_key'];
            paymentController.websitePaytm = gateway.parameters!['WEBSITE'];
            paymentController.industryTypePaytm = gateway.parameters!['INDUSTRY_TYPE_ID'];
            paymentController.channelIdPaytm = gateway.parameters!['CHANNEL_ID'];
            paymentController.transactionUrlPaytm = gateway.parameters!['transaction_url'];
            paymentController.transactionStatusUrlPaytm = gateway.parameters!['transaction_status_url'];
          }

          //FlutterWave
          if (gateway.name.toLowerCase() == "flutterwave") {
            paymentController.publicKeyFlutterWave = gateway.parameters!['public_key'];
            paymentController.secretKeyFlutterWave = gateway.parameters!['secret_key'];
            paymentController.encryptedKeyFlutterWave = gateway.parameters!['encryption_key'];
          }

          //Paypal
          if (gateway.name.toLowerCase() == "paypal") {
            paymentController.clientIdPaypal = gateway.parameters!['cleint_id'];
            paymentController.secretKeyPaypal = gateway.parameters!['secret'];
          }

          //PayStack
          if (gateway.name.toLowerCase() == "paystack") {
            paymentController.publicKeyPayStack = gateway.parameters!['public_key'];
            paymentController.secretKeyPayStack = gateway.parameters!['secret_key'];
          }

          //Monnify
          if (gateway.name.toLowerCase() == "monnify") {
            paymentController.apiKeyMonnify = gateway.parameters!['api_key'];
            paymentController.secretKeyMonnify = gateway.parameters!['secret_key'];
            paymentController.contactCodeMonnfiy = gateway.parameters!['contract_code'];
          }
        }

        errorMessage = '';
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        if (kDebugMode) {
          print('Failed to laod data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to laod data!');
      }
    } catch (e) {
      errorMessage = 'Failed to laod data!';
      if (kDebugMode) {
        print("$e");
      }
      isLoading = false;
      isScreenLoading = false;
      update();
    } finally {
      isLoading = false;
      isScreenLoading = false;
    }
  }

  // submit payment info (BANK TRANSFER / ID GREATER THAN 999)
  Future<void> submitManualPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.manualPaymentUri}';
      Map<String, String> request = {};

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = paymentPreview!.id.toString();
      request['gatewayId'] = selectedGateway!.id.toString();

      // Add text field values to formData
      manualPaymentParameters.forEach((fieldName, controller) {
        request[fieldName] = controller.text;
      });

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        // ereasing text form field
        for (var controller in manualPaymentParameters.values) {
          controller.clear();
        }
        if (data['status'].toLowerCase() == "success") {
          Get.toNamed(BillRequestScreen.routeName);
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, data['status'], data['message']);
        } else {
          Get.offNamed(BillPayScreen.routeName);
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, data['status'], data['message']);
        }

        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print('Failed to send data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw ("Failed to send data");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to send data: $e");
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // submit wallet payment info (WALLET)
  Future<void> submitWalletPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.walletPaymentUri}';
      Map<String, String> request = {};

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = paymentPreview!.id.toString();

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        if (data['status'].toLowerCase() == "success") {
          Get.toNamed(PayListScreen.routeName);
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, data['status'], data['message']);
        } else {
          Get.offNamed(BillPayScreen.routeName);
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, data['status'], data['message']);
        }

        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print('Failed to send data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw ("Failed to send data");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to send data: $e");
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // submit automatic payment info (WEBVIEW / ID LESS THAN 1000 & NOT SDK)
  Future<void> submitAutomaticPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.autoPaymentUri}';
      Map<String, String> request = {};

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = paymentPreview!.id.toString();
      request['gatewayId'] = selectedGateway!.id.toString();

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        Get.toNamed(CustomWebView.routeName, arguments: data['message']['url']);

        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print('Failed to send data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw ("Failed to send data");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to send data: $e");
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // submit card payment info (AUTHORIZE.NET, SECURIONPAY / HAVE INDIVIDUAL CARD PAYMENT SCREEN)
  Future<void> submitCardPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.cardPaymentUri}';
      Map<String, String> request = {};

      // split month and year
      List<String> parts = expiryDate.split('/');

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = paymentPreview!.id.toString();
      request['gatewayId'] = selectedGateway!.id.toString();
      request['card_number'] = cardNumber;
      request['card_name'] = cardHolderName;
      request['expiry_month'] = parts[0];
      request['expiry_year'] = parts[1];
      request['card_cvc'] = cvvCode;

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        if (data['status'].toLowerCase() == "success") {
          Get.toNamed(PayListScreen.routeName);
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, data['status'], data['message']);
        } else {
          Get.offNamed(BillPayScreen.routeName);
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, data['status'], data['message']);
        }
        cardNumber = "";
        cardHolderName = "";
        expiryDate = "";
        cvvCode = "";

        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print('Failed to submitCardPayment. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw ("Failed to submitCardPayment");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to submitCardPayment: $e");
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }
}
