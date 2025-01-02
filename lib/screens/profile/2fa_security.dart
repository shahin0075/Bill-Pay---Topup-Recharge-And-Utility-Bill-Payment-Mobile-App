import 'package:bill_payment/controller/2fa_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TwoFactorAuthenticationScreen extends StatefulWidget {
  static const String routeName = "/twoFactorAuthenticationScreen";
  const TwoFactorAuthenticationScreen({super.key});

  @override
  State<TwoFactorAuthenticationScreen> createState() => _TwoFactorAuthenticationScreenState();
}

class _TwoFactorAuthenticationScreenState extends State<TwoFactorAuthenticationScreen> {
  final twoFaController = Get.put(TwoFaController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    twoFaController.fetchTwoFactorInfo();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoFaController>(
      builder: (twoFaController) {
        return Scaffold(
          backgroundColor: CustomColors.getBodyColor(),
          body: Stack(
            children: [
              Positioned(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        "assets/background.png",
                        fit: BoxFit.cover,
                        height: 120,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(top: 50.h),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  hoverColor: CustomColors.primaryColor,
                                  padding: EdgeInsets.all(0.w),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.back,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                                ),
                                Text(
                                  languageData['Two Factor'] ?? 'Two Factor',
                                  style: GoogleFonts.jost(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    CupertinoIcons.settings,
                                    color: Colors.transparent,
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              twoFaController.twoFactorInfo != null
                  ? Container(
                      padding: EdgeInsets.only(top: 115.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                              padding: EdgeInsets.all(20.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: CustomColors.getContainerColor(),
                                boxShadow: [
                                  BoxShadow(
                                    color: CustomColors.getShadowColor(),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 52.h,
                                          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                          decoration: BoxDecoration(
                                            color: CustomColors.getInputColor(),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.w),
                                              bottomLeft: Radius.circular(8.w),
                                            ),
                                          ),
                                          child: Text(twoFaController.textToCopy!),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => twoFaController.copyToClipboard(context),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                          width: 80.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8.w),
                                              bottomRight: Radius.circular(8.w),
                                            ),
                                            color: CustomColors.primaryColor,
                                          ),
                                          child: Text(
                                            languageData['Copy'] ?? 'Copy',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.jost(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    languageData['Scan The QR Code'] ?? 'Scan The QR Code',
                                    style: GoogleFonts.jost(
                                      fontSize: 18.sp,
                                      color: CustomColors.getTitleColor(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  QrImageView(
                                    data: twoFaController.twoFactorInfo!.qrCodeUrl,
                                    version: QrVersions.auto,
                                    size: 180.0,
                                    backgroundColor: CustomColors.whiteColor,
                                  ),
                                  SizedBox(height: 20.h),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            // titlePadding: EdgeInsets.all(20.w),
                                            backgroundColor: CustomColors.getContainerColor(),
                                            surfaceTintColor: Colors.transparent,
                                            content: Form(
                                              key: twoFaController.formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: languageData['Verify Your OTP'] ?? 'Verify Your OTP',
                                                          style: GoogleFonts.jost(
                                                            color: CustomColors.getTitleColor(),
                                                            fontSize: 20.sp,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        hoverColor: CustomColors.primaryColor,
                                                        padding: EdgeInsets.all(0.w),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        icon: Icon(
                                                          CupertinoIcons.clear,
                                                          color: CustomColors.getTitleColor(),
                                                          size: 20.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  TextFormField(
                                                    controller: twoFaController.authenticationCodeController,
                                                    style: GoogleFonts.getFont(
                                                      'Jost',
                                                      textStyle: TextStyle(
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: languageData['Enter Google Authenticator Code'] ??
                                                          'Enter Google Authenticator Code',
                                                      labelStyle: GoogleFonts.jost(
                                                        color: CustomColors.getTextColor(),
                                                      ),
                                                      contentPadding: EdgeInsets.all(12.w),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8.w),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8.w),
                                                        borderSide: BorderSide(
                                                          color: CustomColors.primaryColor,
                                                          width: 1.w,
                                                        ),
                                                      ),
                                                      filled: true,
                                                      fillColor: CustomColors.getInputColor(),
                                                    ),
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  GestureDetector(
                                                    onTap: () {
                                                      twoFaController.twoFactorInfo!.twoFactorEnable
                                                          ? twoFaController
                                                              .disableTwoFactor(twoFaController.twoFactorInfo!.secret)
                                                              .then((value) => twoFaController.fetchTwoFactorInfo())
                                                          : twoFaController
                                                              .enableTwoFactor(twoFaController.twoFactorInfo!.secret)
                                                              .then((value) => twoFaController.fetchTwoFactorInfo());
                                                      Navigator.of(context).pop(); // Close the filter dialog
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                                                      width: 300.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: CustomColors.primaryColor,
                                                      ),
                                                      child: !twoFaController.isLoading
                                                          ? Text(
                                                              languageData["Verify"] ?? 'Verify',
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.jost(
                                                                color: CustomColors.whiteColor,
                                                                fontSize: 16.sp,
                                                              ),
                                                            )
                                                          : Center(
                                                              child: SizedBox(
                                                                width: 23.w,
                                                                height: 23.h,
                                                                child: const CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                      CustomColors.whiteColor),
                                                                  strokeWidth: 2.0,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.w),
                                        color: CustomColors.primaryColor,
                                      ),
                                      child: Text(
                                        twoFaController.twoFactorInfo!.twoFactorEnable != true
                                            ? languageData["Enable Two Factor Authentication"] ??
                                                "Enable Two Factor Authentication"
                                            : languageData["Disable Two Factor Authentication"] ??
                                                "Disable Two Factor Authentication",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.jost(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                              padding: EdgeInsets.all(20.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: CustomColors.getContainerColor(),
                                boxShadow: [
                                  BoxShadow(
                                    color: CustomColors.getShadowColor(),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    languageData['Use Google Authenticator to Scan the QR code or use the code'] ??
                                        'Use Google Authenticator to Scan the QR code or use the code',
                                    style: GoogleFonts.jost(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.getTitleColor(),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    languageData[
                                            "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the 2-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device."] ??
                                        "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the 2-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device.",
                                    style: GoogleFonts.jost(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: CustomColors.getTextColor(),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  GestureDetector(
                                    onTap: twoFaController.openStore,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.w),
                                        color: CustomColors.primaryColor,
                                      ),
                                      child: Text(
                                        languageData["Download App"] ?? "Download App",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.jost(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                        strokeWidth: 2.0,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
