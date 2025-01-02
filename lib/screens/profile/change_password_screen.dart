import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/profile_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = "/changePasswordScreen";
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final profileController = Get.put(ProfileController());
  bool _obscurePassword = true;

  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Scaffold(
        backgroundColor: CustomColors.getBodyColor(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                                  Get.back();
                                },
                                icon: Icon(
                                  CupertinoIcons.back,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              Text(
                                languageData["Change Password"] ?? "Change Password",
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                padding: EdgeInsets.all(20.w),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: profileController.currentPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageData['Please enter your password'] ?? 'Please enter your password';
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
                          labelText: languageData["Current Password"] ?? "Current Password",
                          labelStyle: GoogleFonts.jost(
                            color: CustomColors.getTextColor(),
                          ),
                          contentPadding: EdgeInsets.all(14.w),
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
                          errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                          filled: true,
                          fillColor: CustomColors.getInputColor(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                              color: Colors.grey,
                              size: 20.sp,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: profileController.newPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageData['Please enter your new password'] ?? 'Please enter your new password';
                          }
                          // if (value.length < 8) {
                          //   return 'Password must be at least 8 characters long';
                          // }
                          // if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          //   return 'Password must contain at least one uppercase letter';
                          // }
                          // if (!RegExp(r'[a-z]').hasMatch(value)) {
                          //   return 'Password must contain at least one lowercase letter';
                          // }
                          // if (!RegExp(r'[0-9]').hasMatch(value)) {
                          //   return 'Password must contain at least one digit';
                          // }
                          // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          //   return 'Password must contain at least one special character';
                          // }
                          return null;
                        },
                        style: GoogleFonts.getFont(
                          'Jost',
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        decoration: InputDecoration(
                          labelText: languageData["New Password"] ?? "New Password",
                          labelStyle: GoogleFonts.jost(
                            color: CustomColors.getTextColor(),
                          ),
                          contentPadding: EdgeInsets.all(14.w),
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
                          errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                          filled: true,
                          fillColor: CustomColors.getInputColor(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                              color: Colors.grey,
                              size: 20.sp,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: profileController.confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageData['Please enter your confirm password'] ??
                                'Please enter your confirm password';
                          }
                          if (value != profileController.confirmPasswordController.text) {
                            return languageData['Passwords do not match'] ?? 'Passwords do not match';
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
                          labelText: languageData["Confirm Password"] ?? "Confirm Password",
                          labelStyle: GoogleFonts.jost(
                            color: CustomColors.getTextColor(),
                          ),
                          contentPadding: EdgeInsets.all(14.w),
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
                          errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                          filled: true,
                          fillColor: CustomColors.getInputColor(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                              color: Colors.grey,
                              size: 20.sp,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            profileController.changePassword();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                          width: 300.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CustomColors.primaryColor,
                          ),
                          child: !profileController.isLoading
                              ? Text(
                                  languageData["Change Password"] ?? "Change Password",
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
              ),
            ],
          ),
        ),
      );
    });
  }
}
