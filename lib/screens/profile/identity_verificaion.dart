import 'dart:io';
import 'package:bill_payment/controller/kyc_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class IdentityVerificationScreen extends StatefulWidget {
  static const String routeName = "/identityVerificationScreen";
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() => _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen> {
  final kycController = Get.put(KycController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    kycController.fetchKYCData();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycController>(
      builder: (kycController) {
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
                                  languageData["Identity Verification"] ?? "Identity Verification",
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
              !kycController.isScreenLoading
                  ? buildKycStatusWidget(kycController.kycStatus)
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

  Widget buildKycStatusWidget(String status) {
    if (status.toLowerCase().contains("verifieds")) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 200, height: 150, child: Lottie.asset("assets/icon/verified.json")),
            Text(
              status,
              style: GoogleFonts.jost(
                color: CustomColors.getTitleColor(),
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else if (status.toLowerCase().contains("pending")) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 250, height: 200, child: Lottie.asset("assets/icon/pending.json")),
            Text(
              status,
              style: GoogleFonts.jost(
                color: CustomColors.getTitleColor(),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ); // Replace with your pending widget
    } else if (status.toLowerCase().contains("rejected")) {
      return Container(
        padding: EdgeInsets.only(top: 115.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jost(
                    color: CustomColors.secondaryColor,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var fieldName in kycController.kycData.entries) buildFormField(fieldName.key),
                    GestureDetector(
                      onTap: () {
                        kycController.submitKYC();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                        width: 300.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomColors.primaryColor,
                        ),
                        child: !kycController.isLoading
                            ? Text(
                                languageData["Submit"] ?? "Submit",
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
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 115.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var fieldName in kycController.kycData.entries) buildFormField(fieldName.key),
                    GestureDetector(
                      onTap: () {
                        kycController.submitKYC();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                        width: 300.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomColors.primaryColor,
                        ),
                        child: !kycController.isLoading
                            ? Text(
                                languageData["Submit"] ?? "Submit",
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
            ],
          ),
        ),
      );
    }
  }

  Widget buildFormField(dynamic fieldName) {
    var field = kycController.kycData[fieldName];
    TextEditingController controller = kycController.textControllers[fieldName]!;

    if (field['type'] == 'text') {
      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: TextFormField(
          controller: controller,
          style: GoogleFonts.getFont(
            'Jost',
            textStyle: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          decoration: InputDecoration(
            labelText: field['field_level'],
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
            filled: true,
            fillColor: CustomColors.getInputColor(),
          ),
          validator: (value) {
            if (field['validation'] == 'required' && value!.isEmpty) {
              return languageData['This field is required'] ?? 'This field is required';
            }
            return null;
          },
        ),
      );
    } else if (field['type'] == 'textarea') {
      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: TextFormField(
          controller: controller,
          maxLines: 3,
          style: GoogleFonts.getFont(
            'Jost',
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: CustomColors.getTitleColor(),
            ),
          ),
          decoration: InputDecoration(
            labelText: languageData["Address"] ?? "Address",
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
            filled: true,
            fillColor: CustomColors.getInputColor(),
          ),
          validator: (value) {
            if (field['validation'] == 'required' && value!.isEmpty) {
              return languageData['This field is required'] ?? 'This field is required';
            }
            return null;
          },
        ),
      );
    } else if (field['type'] == 'file') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field['field_level'],
            style: GoogleFonts.jost(
              color: CustomColors.getTextColor(),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          DottedBorder(
            dashPattern: const [8, 4],
            strokeWidth: 1.w,
            strokeCap: StrokeCap.round,
            borderType: BorderType.RRect,
            radius: Radius.circular(10.w),
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(color: CustomColors.getInputColor(), borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.w),
                    child: kycController.pickedFiles[fieldName] == null
                        ? Image.asset(
                            "assets/icon/upload_file.png",
                            width: 64.w,
                            height: 64.h,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            kycController.pickedFiles[fieldName]!,
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () async {
                      final imagePicker = ImagePicker();
                      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          kycController.pickedFiles[fieldName] = File(pickedFile.path);
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
                      width: 120.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        color: CustomColors.primaryColor,
                      ),
                      child: Text(
                        languageData["Choose file"] ?? "Choose file",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jost(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      );
    } else {
      return const SizedBox.shrink(); // Return an empty widget for unknown field types
    }
  }
}
