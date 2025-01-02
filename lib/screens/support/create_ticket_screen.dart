import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/ticket_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTicketScreen extends StatefulWidget {
  static const String routeName = "/createTicketScreen";
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final controller = Get.put(TicketController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketController>(builder: (controller) {
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
                                languageData["Create Ticket"] ?? "Create Ticket",
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
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: controller.subjectController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageData['Please enter your subject'] ?? 'Please enter your subject';
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
                          labelText: languageData["Subject"] ?? "Subject",
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
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: controller.messageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageData['Please enter your message'] ?? 'Please enter your message';
                          }
                          return null;
                        },
                        maxLines: 3,
                        style: GoogleFonts.getFont(
                          'Jost',
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        decoration: InputDecoration(
                          labelText: languageData["Message"] ?? "Message",
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
                        ),
                      ),
                      SizedBox(height: 16.h),
                      DottedBorder(
                        dashPattern: const [8, 4],
                        strokeWidth: 1,
                        strokeCap: StrokeCap.round,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10.w),
                        color: Colors.transparent,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: CustomColors.getInputColor(),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              controller.selectedFiles.isNotEmpty
                                  ? ListView.builder(
                                      padding: EdgeInsets.all(0.w),
                                      shrinkWrap: true,
                                      itemCount: controller.selectedFiles.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(vertical: 5.h),
                                          padding: EdgeInsets.only(left: 10.w),
                                          decoration: BoxDecoration(
                                              color: CustomColors.getContainerColor(),
                                              borderRadius: BorderRadius.circular(4)),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(0.w),
                                            dense: true,
                                            title: Text(
                                              controller.selectedFiles[index].path.split('/').last,
                                              maxLines: 1,
                                              style: GoogleFonts.jost(
                                                color: CustomColors.getTextColor(),
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () => controller.removeFile(index),
                                              icon: const Icon(
                                                CupertinoIcons.delete,
                                                color: CustomColors.orangeColor,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      "assets/icon/upload_file.png",
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.contain,
                                    ),
                              SizedBox(height: 16.h),
                              GestureDetector(
                                onTap: controller.pickFiles,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
                                  width: 120.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.w),
                                    color: CustomColors.primaryColor,
                                  ),
                                  child: Text(
                                    languageData["Select files"] ?? "Select files",
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
                      GestureDetector(
                        onTap: () {
                          if (controller.formKey.currentState!.validate()) {
                            controller.createTicket();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                          width: 300.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CustomColors.primaryColor,
                          ),
                          child: !controller.isLoading
                              ? Text(
                                  languageData["Create Ticket"] ?? "Create Ticket",
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
