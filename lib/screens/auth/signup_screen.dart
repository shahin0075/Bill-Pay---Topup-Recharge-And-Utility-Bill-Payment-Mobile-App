import 'package:bill_payment/controller/auth_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signUpScreen";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String initialCountry = 'US';
  String? phoneCode;

  final authController = Get.put(AuthController());
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
                  child: Form(
                    key: _formKey,
                    // autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          languageData["Create an Account"] ?? "Create an Account",
                          style: TextStyle(
                            color: CustomColors.getTitleColor(),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          languageData["Hello there! Sign up to continue."] ?? "Hello there! Sign up to continue.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.getTextColor(),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageData['Please enter your name'] ?? 'Please enter your name';
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
                            hintText: languageData['Name'] ?? 'Name',
                            contentPadding: EdgeInsets.all(14.w),
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              size: 18.w,
                            ),
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
                        TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageData['Please enter your username'] ?? 'Please enter your username';
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
                            hintText: languageData['Username'] ?? 'Username',
                            contentPadding: EdgeInsets.all(14.w),
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              size: 18.w,
                            ),
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
                        Stack(
                          children: [
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 102.w,
                                  height: 52.h,
                                  decoration: BoxDecoration(
                                      color: CustomColors.getInputColor(),
                                      borderRadius: BorderRadius.circular(
                                        8.w,
                                      )),
                                )),
                            Container(
                              padding: EdgeInsets.only(left: 10.w),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  // Handle phone number input changes
                                  // print(number.phoneNumber);
                                  phoneCode = number.phoneNumber;
                                },
                                selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.onUserInteraction,
                                selectorTextStyle: GoogleFonts.getFont(
                                  'Jost',
                                  textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                ),
                                initialValue: PhoneNumber(isoCode: initialCountry),
                                textFieldController: _phoneNumberController,
                                textStyle: GoogleFonts.getFont(
                                  'Jost',
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                // bottom sheet search box decoration
                                searchBoxDecoration: InputDecoration(
                                  hintText: languageData['Search'] ?? 'Search',
                                  hintStyle: GoogleFonts.getFont(
                                    'Jost',
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    CupertinoIcons.search,
                                    size: 18.w,
                                  ),
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
                                  filled: true,
                                  fillColor: CustomColors.getInputColor2(),
                                ),
                                errorMessage: languageData["Invalid phone number"] ?? "Invalid phone number",
                                // input field decoration
                                inputDecoration: InputDecoration(
                                  hintText: languageData['Phone'] ?? 'Phone',
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
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageData['Please enter your email'] ?? 'Please enter your email';
                            }
                            // Use a regular expression to check if the email is valid
                            bool isValidEmail = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                            ).hasMatch(value);

                            if (!isValidEmail) {
                              return languageData['Please enter a valid email address'] ??
                                  'Please enter a valid email address';
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
                            hintText: languageData['Email'] ?? 'Email',
                            contentPadding: EdgeInsets.all(14.w),
                            prefixIcon: Icon(
                              CupertinoIcons.mail,
                              size: 18.w,
                            ),
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
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageData['Please enter your password'] ?? 'Please enter your password';
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
                            hintText: languageData["Password"] ?? "Password",
                            contentPadding: EdgeInsets.all(14.w),
                            prefixIcon: Icon(
                              CupertinoIcons.lock,
                              size: 18.w,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
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
                          obscureText: _obscurePassword,
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageData['Please confirm your password'] ?? 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
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
                            hintText: languageData["Confirm Password"] ?? "Confirm Password",
                            contentPadding: EdgeInsets.all(14.w),
                            prefixIcon: Icon(
                              CupertinoIcons.lock,
                              size: 18.w,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
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
                          obscureText: _obscurePassword,
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              authController.signUp(
                                _nameController.text,
                                _usernameController.text,
                                _emailController.text,
                                phoneCode!,
                                _phoneNumberController.text,
                                _passwordController.text,
                                _confirmPasswordController.text,
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
                                    languageData["Sign Up"] ?? "Sign Up",
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
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            languageData["Already have an account? Sign In"] ?? "Already have an account? Sign In",
                            style: GoogleFonts.jost(
                              color: CustomColors.getTitleColor(),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
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
