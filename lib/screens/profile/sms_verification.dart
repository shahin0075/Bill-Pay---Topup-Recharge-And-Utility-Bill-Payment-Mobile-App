import 'package:bill_payment/controller/auth_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SmsVerification extends StatefulWidget {
  static const String routeName = "/smsVerification";
  const SmsVerification({super.key});

  @override
  State<SmsVerification> createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: CustomColors.getBodyColor2(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              Get.isDarkMode ? 'assets/overlay_dark.png' : 'assets/overlay.png',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Verify Your SMS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CustomColors.getTitleColor(),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Please enter the code sent to your email.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CustomColors.getTextColor(),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            TextFormField(
                              controller: _codeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your verification code';
                                }
                                return null;
                              },
                              style: GoogleFonts.getFont(
                                'Jost',
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Code',
                                contentPadding: EdgeInsets.all(14.w),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: CustomColors.primaryColor,
                                    width: 1.w,
                                  ),
                                ),
                                errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                filled: true,
                                fillColor: CustomColors.getInputColor2(),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  // Form is valid, perform desired action
                                  authController.smsVerification(
                                    _codeController.text,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                width: 300.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: CustomColors.primaryColor,
                                ),
                                child: !authController.isLoading
                                    ? Text(
                                        "Submit Code",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.jost(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      )
                                    : Center(
                                        child: SizedBox(
                                          width: 23.w,
                                          height: 23.h,
                                          child: const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(CustomColors.whiteColor),
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () {
                          authController.resendCode("mobile");
                        },
                        child: Text(
                          "Resend code",
                          style: GoogleFonts.jost(
                            color: CustomColors.primaryColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
