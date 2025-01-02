import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/notification_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPermissionScreen extends StatefulWidget {
  static const String routeName = "/notificationPermissionScreen";
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends State<NotificationPermissionScreen> {
  final controller = Get.put(NotificationController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  void toggleSwitch(String templateKey, List<String> templateList) {
    setState(() {
      if (isActive(templateKey, templateList)) {
        templateList.remove(templateKey);
      } else {
        templateList.add(templateKey);
      }
    });
  }

  bool isActive(String templateKey, List<String> templateList) {
    return templateList.contains(templateKey);
  }

  @override
  void initState() {
    super.initState();
    controller.fetchData();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (controller) {
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
                                  languageData["Notification Permission"] ?? "Notification Permission",
                                  style: GoogleFonts.jost(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  hoverColor: CustomColors.primaryColor,
                                  onPressed: () {},
                                  icon: Icon(
                                    CupertinoIcons.settings,
                                    color: Colors.white,
                                    size: 0.sp,
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
              !controller.isScreenLoading
                  ? Container(
                      padding: EdgeInsets.only(top: 115.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   itemCount: controller.userActiveEmail.length,
                                  //   itemBuilder: (context, index) {
                                  //     return ListTile(
                                  //       title: Text(controller.userActiveEmail[index]),
                                  //     );
                                  //   },
                                  // ),
                                  ListView.builder(
                                    padding: EdgeInsets.all(0.w),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.notificationPermissions.length,
                                    itemBuilder: (context, index) {
                                      final item = controller.notificationPermissions[index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.w),
                                          color: CustomColors.getInputColor(),
                                        ),
                                        child: ExpansionTile(
                                          shape: Border.all(color: Colors.transparent),
                                          tilePadding: EdgeInsets.all(0.w),
                                          iconColor: CustomColors.primaryColor,
                                          collapsedTextColor: CustomColors.getTitleColor(),
                                          textColor: CustomColors.primaryColor,
                                          title: Text(
                                            controller.capitalizeEachWord(item.name.toLowerCase()),
                                            maxLines: 1,
                                            style: GoogleFonts.jost(
                                              // color: CustomColors.getTitleColor(),
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          children: [
                                            ListTile(
                                              contentPadding: EdgeInsets.all(0.w),
                                              dense: true,
                                              title: Text(
                                                languageData["Email"] ?? "Email",
                                                maxLines: 1,
                                                style: GoogleFonts.jost(
                                                  color: CustomColors.getTextColor(),
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              trailing: Transform.scale(
                                                scale: .8,
                                                child: CupertinoSwitch(
                                                  activeColor: CustomColors.primaryColor,
                                                  value: isActive(item.templateKey, controller.userActiveEmail),
                                                  onChanged: item.mailStatus == 1
                                                      ? (value) {
                                                          toggleSwitch(item.templateKey, controller.userActiveEmail);
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.all(0.w),
                                              dense: true,
                                              title: Text(
                                                languageData["Sms"] ?? "Sms",
                                                maxLines: 1,
                                                style: GoogleFonts.jost(
                                                  color: CustomColors.getTextColor(),
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              trailing: Transform.scale(
                                                scale: .8,
                                                child: CupertinoSwitch(
                                                  activeColor: CustomColors.primaryColor,
                                                  value: isActive(item.templateKey, controller.userActiveSms),
                                                  onChanged: item.smsStatus == 1
                                                      ? (value) {
                                                          toggleSwitch(item.templateKey, controller.userActiveSms);
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.all(0.w),
                                              dense: true,
                                              title: Text(
                                                languageData["Push"] ?? "Push",
                                                maxLines: 1,
                                                style: GoogleFonts.jost(
                                                  color: CustomColors.getTextColor(),
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              trailing: Transform.scale(
                                                scale: .8,
                                                child: CupertinoSwitch(
                                                  activeColor: CustomColors.primaryColor,
                                                  value: isActive(item.templateKey, controller.userActivePush),
                                                  onChanged: item.pushStatus == 1
                                                      ? (value) {
                                                          toggleSwitch(item.templateKey, controller.userActivePush);
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.all(0.w),
                                              dense: true,
                                              title: Text(
                                                languageData["In App"] ?? "In App",
                                                maxLines: 1,
                                                style: GoogleFonts.jost(
                                                  color: CustomColors.getTextColor(),
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              trailing: Transform.scale(
                                                scale: .8,
                                                child: CupertinoSwitch(
                                                  activeColor: CustomColors.primaryColor,
                                                  value: isActive(item.templateKey, controller.userActiveInApp),
                                                  onChanged: item.inAppStatus == 1
                                                      ? (value) {
                                                          toggleSwitch(item.templateKey, controller.userActiveInApp);
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                                  GestureDetector(
                                    onTap: controller.sendDataToApi,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                      width: 300.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: CustomColors.primaryColor,
                                      ),
                                      child: !controller.isLoading
                                          ? Text(
                                              languageData["Save Changes"] ?? "Save Changes",
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
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                        strokeWidth: 2.0,
                      ),
                    ),
            ],
          ));
    });
  }
}
