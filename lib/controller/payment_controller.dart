import 'dart:convert';
import 'dart:io';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/bill/pay_list_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:bill_payment/widgets/custom_alert_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SdkPaymentHandle extends GetxController {
  bool isLoading = false;
  String currency = "USD";

  //Stripe
  dynamic stripeSecretKey;
  dynamic stripePublisherKey;

  //Razorpay
  dynamic keyIdRazorPay;
  dynamic keySecretRazorPay;

  //Paytm
  dynamic midPaytm;
  dynamic merchantKeyPaytm;
  dynamic websitePaytm;
  dynamic industryTypePaytm;
  dynamic channelIdPaytm;
  dynamic transactionUrlPaytm;
  dynamic transactionStatusUrlPaytm;

  //FlutterWave
  dynamic publicKeyFlutterWave;
  dynamic secretKeyFlutterWave;
  dynamic encryptedKeyFlutterWave;

  //Paypal
  dynamic clientIdPaypal;
  dynamic secretKeyPaypal;

  //PayStack
  dynamic publicKeyPayStack;
  dynamic secretKeyPayStack;

  //Monnify
  dynamic apiKeyMonnify;
  dynamic secretKeyMonnify;
  dynamic contactCodeMonnfiy;

  // id
  dynamic billPayId;
  dynamic gatewayId;

  @override
  void onInit() {
    super.onInit();
    // razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);

    // monnify
    initializeMonnify();

    // paystack
    plugin.initialize(publicKey: paystackPublicKey);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  // submit SDK payment info -------------------------------------------------------------------------------------------
  Future<void> paymentDoneRequest() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.paymentDoneUri}';
      Map<String, String> request = {};

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = billPayId;
      request['gatewayId'] = gatewayId;

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
        throw ("Failed to send data throw");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to send data catch: $e");
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // start stripe integration ------------------------------------------------------------------------------------------
  Map<String, dynamic>? paymentIntentData;

  Future<void> stripeMakePayment({required String amount}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance
            .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetails: const BillingDetails(
                    name: 'YOUR NAME',
                    email: 'YOUREMAIL@gmail.com',
                    phone: 'YOUR NUMBER',
                    address: Address(
                        city: 'YOUR CITY',
                        country: 'YOUR COUNTRY',
                        line1: 'YOUR ADDRESS 1',
                        line2: 'YOUR ADDRESS 2',
                        postalCode: 'YOUR PINCODE',
                        state: 'YOUR STATE'),
                  ),
                  customerId: paymentIntentData!['customer'],
                  paymentIntentClientSecret: paymentIntentData!['client_secret'], //Gotten from payment intent
                  customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'),
            )
            .then((value) {});
      }

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      paymentDoneRequest();
      if (kDebugMode) {
        print('Payment succesfully completed');
      }
    } on Exception catch (e) {
      if (e is StripeException) {
        if (kDebugMode) {
          print('Error from Stripe: ${e.error.localizedMessage}');
        }
      } else {
        if (kDebugMode) {
          print('Unforeseen error: $e');
        }
      }
    }
  }

  //create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer $stripeSecretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = double.parse(amount).toInt() * 100;
    return calculatedAmount.toString();
  }
  // end stripe integration --------------------------------------------------------------------------------------------

  // start razorpay integration ----------------------------------------------------------------------------------------
  late Razorpay _razorpay;
  Future<void> razorpayMakePayment({required String amount}) async {
    var options = {
      'key': keyIdRazorPay,
      'amount': calculateAmount(amount),
      'name': 'Your App Name',
      'description': 'Payment for some awesome product',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    if (kDebugMode) {
      print(
          "Payment Failed, Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    }
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    paymentDoneRequest();
    if (kDebugMode) {
      print("Payment Successful, Payment ID: ${response.paymentId}");
    }
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    if (kDebugMode) {
      print("External Wallet Selected, ${response.walletName}");
    }
  }
  // end razorpay integration ------------------------------------------------------------------------------------------

  // start flutterwave integration -------------------------------------------------------------------------------------
  Future<void> flutterwaveMakePayment({required String amount}) async {
    final Customer customer = Customer(email: "customer@customer.com");

    final Flutterwave flutterwave = Flutterwave(
      context: Get.context!,
      publicKey: publicKeyFlutterWave,
      currency: "USD",
      redirectUrl: AppConstants.baseUri,
      amount: calculateAmount(amount),
      customer: customer,
      paymentOptions: "card, payattitude, barter, bank transfer, ussd",
      customization: Customization(title: "Test Payment"),
      // isTestMode: true,
      isTestMode: false,
      txRef: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    final ChargeResponse response = await flutterwave.charge();
    if (response.status == '200') {
      paymentDoneRequest();
      if (kDebugMode) {
        print("${response.toJson()}");
      }
    } else {
      CustomAlertDialog.showAlertDialog(Get.overlayContext!, "failed", "Your payment has not completed!");
    }
  }
  // end flutterwave integration ---------------------------------------------------------------------------------------

  // start monnify integration -----------------------------------------------------------------------------------------
  late Monnify? monnify;

  void initializeMonnify() async {
    monnify = await Monnify.initialize(
      // applicationMode: ApplicationMode.TEST,
      applicationMode: ApplicationMode.LIVE,
      apiKey: "MK_TEST_LB5KJDYD65", // TODO: replace with dynamic apiKeyMonnify
      contractCode: '5566252118',
    );
  }

  Future<void> monnifyMakePayment({required double amount}) async {
    final paymentReference = DateTime.now().millisecondsSinceEpoch.toString();
    String formattedAmount = amount.toStringAsFixed(2);

    final transaction = TransactionDetails().copyWith(
      amount: double.parse(formattedAmount),
      currencyCode: 'NGN', // didn't support other currencies
      customerName: 'Customer Name',
      customerEmail: 'customer@email.com',
      paymentReference: paymentReference,
      metaData: {"ip": "196.168.45.22", "device": "mobile"},
      // paymentMethods: [PaymentMethod.CARD, PaymentMethod.ACCOUNT_TRANSFER, PaymentMethod.USSD],
      /*incomeSplitConfig: [SubAccountDetails("MFY_SUB_319452883968", 10.5, 500, true),
          SubAccountDetails("MFY_SUB_259811283666", 10.5, 1000, false)]*/
    );

    try {
      final response = await monnify?.initializePayment(transaction: transaction);
      paymentDoneRequest();
      if (kDebugMode) {
        print("monnify response: ${response.toString()}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('monnify error: $e');
      }
      CustomAlertDialog.showAlertDialog(Get.overlayContext!, "failed", "Your payment has not completed!");
    }
  }

  // end monnify integration -------------------------------------------------------------------------------------------

  // start paytm integration -------------------------------------------------------------------------------------------
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  String txnToken = "docss";
  String result = "";
  bool isStaging = false;
  bool isApiCallInprogress = false;
  String callbackUrl = AppConstants.baseUri;
  bool restrictAppInvoke = false;
  bool enableAssist = true;

  Future<void> paytmMakePayment({required String amount}) async {
    if (txnToken.isEmpty) {
      return;
    }
    var sendMap = <String, dynamic>{
      "mid": midPaytm,
      "orderId": orderId,
      "amount": calculateAmount(amount),
      "txnToken": txnToken,
      "callbackUrl": callbackUrl,
      "isStaging": isStaging,
      "restrictAppInvoke": restrictAppInvoke,
      "enableAssist": enableAssist
    };
    if (kDebugMode) {
      print(sendMap);
    }

    try {
      var response = AllInOneSdk.startTransaction(midPaytm, orderId, calculateAmount(amount), txnToken, callbackUrl,
          isStaging, restrictAppInvoke, enableAssist);
      response.then((value) {
        paymentDoneRequest();
        result = value.toString();
        if (kDebugMode) {
          print(result);
        }
        update();
      }).catchError((onError) {
        if (onError is PlatformException) {
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, "failed", "Your payment has not completed!");
          result = "${onError.message} \n  ${onError.details}";
          if (kDebugMode) {
            print(result);
          }
          update();
        } else {
          CustomAlertDialog.showAlertDialog(Get.overlayContext!, "failed", "Your payment has not completed!");
          result = onError.toString();
          if (kDebugMode) {
            print(result);
          }
          update();
        }
      });
    } catch (err) {
      result = err.toString();
      if (kDebugMode) {
        print(result);
      }
    }
  }
  // end paytm integration --------------------------------------------------------------------------------------------- not completed

  // start paypal integration ------------------------------------------------------------------------------------------
  Future<void> paypalMakePayment({required String amount}) async {
    try {
      Get.to(() => PaypalCheckout(
            sandboxMode: true,
            clientId: clientIdPaypal,
            secretKey: secretKeyPaypal,
            returnURL: "success.snippetcoder.com",
            cancelURL: "cancel.snippetcoder.com",
            transactions: [
              {
                "amount": {
                  "total": calculateAmount(amount),
                  "currency": currency,
                  "details": {
                    "subtotal": calculateAmount(amount),
                    "shipping": '0',
                    "shipping_discount": 0,
                  },
                },
                "description": "The payment transaction description.",
              },
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              paymentDoneRequest();
              if (kDebugMode) {
                print("paypal onSuccess: $params");
              }
              // Implement your success logic here
            },
            onError: (error) {
              CustomAlertDialog.showAlertDialog(Get.overlayContext!, "failed", "Your payment has not completed!");
              if (kDebugMode) {
                print("paypal onError: $error");
              }
              // Implement your error handling logic here
            },
            onCancel: () {
              CustomAlertDialog.showAlertDialog(Get.overlayContext!, "failed", "Your payment has not completed!");
              if (kDebugMode) {
                print('paypal cancelled:');
              }
              // Implement your cancellation logic here
            },
          ));
    } catch (e) {
      if (kDebugMode) {
        print("Error initiating PayPal checkout: $e");
      }
    }
  }
  // end paypal integration --------------------------------------------------------------------------------------------

  // start paystack integration ----------------------------------------------------------------------------------------
  var paystackPublicKey =
      'pk_test_f922aa1a87101e3fd029e13024006862fdc0b8c7'; // TODO: replace with dynamic publicKeyPayStack
  PaystackPlugin plugin = PaystackPlugin();

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> paystackMakePayment(BuildContext context, {required double amount}) async {
    String formattedAmount = amount.toStringAsFixed(0);

    try {
      Charge charge = Charge()
        ..amount = int.parse(formattedAmount)
        ..reference = _getReference()
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = 'customer@email.com';
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );

      paymentDoneRequest();
      if (kDebugMode) {
        print("paystack response: $response");
      }
    } catch (e) {
      CustomAlertDialog.showAlertDialog(Get.overlayContext!, "failed", "Your payment has not completed!");
      if (kDebugMode) {
        print("Error initiating PayStack checkout: $e");
      }
    }
  }
  // end paystack integration ------------------------------------------------------------------------------------------
}
