import 'package:bill_payment/screens/bill/pay_list_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomWebView extends StatefulWidget {
  static const String routeName = "/webView";
  const CustomWebView({super.key});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  var url = Get.arguments as String;
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.bodyColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          hoverColor: CustomColors.primaryColor,
          padding: EdgeInsets.all(0.w),
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 28.sp,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.primaryColor,
        title: Text(
          "Payment",
          style: GoogleFonts.jost(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(url)),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              if (kDebugMode) {
                print("Check>>>${url.toString()}");
              }

              if (url.toString() == '${AppConstants.baseUri}/success') {
                Get.offAllNamed(PayListScreen.routeName);
                //  Get.dialog(AppPaymentSuccess());
              }
              if (url.toString() == '${AppConstants.baseUri}/failed') {
                Get.offAllNamed(BottomNavBar.routeName);
                // Get.dialog(AppPaymentFail());
              }
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
          )
        ],
      ),
    );
  }
}
