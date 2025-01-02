import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/pusher_controller.dart';
import 'package:bill_payment/screens/notification/notification_permission.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/widgets/not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = "/notificationScreen";
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(PusherController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    // controller.fetchPusherConfig();
    // controller.onConnectPressed();
    // controller.triggerEventAutomatically();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PusherController>(builder: (controller) {
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
                                languageData["Notifications"] ?? "Notifications",
                                style: GoogleFonts.jost(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                hoverColor: CustomColors.primaryColor,
                                onPressed: () => Get.toNamed(NotificationPermissionScreen.routeName),
                                icon: Icon(
                                  CupertinoIcons.settings,
                                  color: Colors.white,
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
            controller.notificationList.isNotEmpty
                ? Container(
                    padding: EdgeInsets.only(top: 120.h, bottom: 15.h),
                    child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    languageData["All Notifications"] ?? "All Notifications",
                                    style: GoogleFonts.jost(
                                      color: CustomColors.getTitleColor(),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.clearNotifications();
                                    },
                                    child: Text(
                                      languageData["Clear all"] ?? "Clear all",
                                      style: GoogleFonts.jost(
                                        color: CustomColors.primaryColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.notificationList.length,
                              itemBuilder: (context, index) {
                                final item = controller.notificationList[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
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
                                    borderRadius: BorderRadius.circular(16.w),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.w),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 45,
                                            height: 45,
                                            color: CustomColors.primaryLight,
                                          ),
                                          Positioned(
                                            top: 10.h,
                                            left: 10.w,
                                            child: Icon(
                                              CupertinoIcons.bell,
                                              color: CustomColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                      item.text,
                                      style: GoogleFonts.jost(
                                        color: CustomColors.getTitleColor(),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(
                                      item.formattedDate,
                                      style: GoogleFonts.jost(
                                        color: CustomColors.getTextColor(),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )),
                  )
                : Center(child: NotFound(errorMessage: languageData["No Notifications!"] ?? "No Notifications!")),
          ],
        ),
      );
    });
  }
}
