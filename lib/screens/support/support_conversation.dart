import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/ticket_controller.dart';
import 'package:bill_payment/screens/support/support_ticket_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SupportConversationScreen extends StatefulWidget {
  static const String routeName = "/supportConversationScreen";
  const SupportConversationScreen({super.key});

  @override
  State<SupportConversationScreen> createState() => _SupportConversationScreenState();
}

class _SupportConversationScreenState extends State<SupportConversationScreen> {
  final controller = Get.put(TicketController());
  var id = Get.arguments as String;
  bool isClosed = true;

  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  bool isVisible = false;
  int selectedIndex = -1;
  changeDateFormat(dynamic time) {
    DateTime dateTime = DateTime.parse(time);
    return DateFormat('d MMM, yy hh:mm a').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    controller.fetchTicketMessage(id);
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: CustomColors.getBodyColor(),
          body: controller.ticketMessages.isNotEmpty
              ? Stack(
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
                                        "${languageData['Ticket'] ?? 'Ticket'}# $id",
                                        style: GoogleFonts.jost(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        hoverColor: CustomColors.primaryColor,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                titlePadding: EdgeInsets.all(0.w),
                                                backgroundColor: CustomColors.whiteColor,
                                                surfaceTintColor: Colors.transparent,
                                                title: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(10.w),
                                                          topRight: Radius.circular(10.w),
                                                        ),
                                                        child: Image.asset(
                                                          "assets/background.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(20.w),
                                                      child: Center(
                                                        child: Text(
                                                          languageData["Confirmation!"] ?? "Confirmation!",
                                                          style: GoogleFonts.jost(
                                                            color: CustomColors.whiteColor,
                                                            fontSize: 20.sp,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 10.h),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: languageData["Do you want to close the ticket?"] ??
                                                            "Do you want to close the ticket?",
                                                        style: GoogleFonts.jost(
                                                          color: CustomColors.getTextColor(),
                                                          fontSize: 16.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 25.h),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                                            width: 100.w,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: CustomColors.secondaryColor,
                                                            ),
                                                            child: Text(
                                                              languageData["No"] ?? "No",
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.jost(
                                                                color: CustomColors.whiteColor,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            controller.messageReply(".", controller.messageId, "2");
                                                            Get.offNamed(SupportTicketScreen.routeName);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                                            width: 100.w,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: CustomColors.primaryColor,
                                                            ),
                                                            child: Text(
                                                              languageData["Yes"] ?? "Yes",
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.jost(
                                                                color: CustomColors.whiteColor,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: Colors.white,
                                          size: 28.sp,
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
                    Container(
                      padding: EdgeInsets.only(bottom: 60.h, top: 115.h),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: controller.ticketMessages.length,
                        itemBuilder: (context, index) {
                          var message = controller.ticketMessages[index];
                          return Column(
                            crossAxisAlignment:
                                message.adminId == null ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                    selectedIndex = index;
                                  });
                                },
                                child: BubbleNormal(
                                  text: message.message,
                                  color: message.adminId == null
                                      ? CustomColors.primaryColor
                                      : CustomColors.getContainerColor(),
                                  tail: true,
                                  isSender: message.adminId == null ? true : false,
                                  textStyle: GoogleFonts.jost(
                                    color: message.adminId == null ? Colors.white : CustomColors.getTextColor(),
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  message.attachments.length,
                                  (index) {
                                    var attachment = message.attachments[index];
                                    return GestureDetector(
                                      onTap: () {
                                        controller.downloadFile(
                                          attachment.attachmentPath,
                                          attachment.attachmentName,
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 5.h),
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color: CustomColors.infoColor,
                                          borderRadius: BorderRadius.circular(110.w),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              attachment.attachmentName,
                                              style: GoogleFonts.jost(
                                                color: CustomColors.whiteColor,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            const Icon(
                                              Icons.cloud_download,
                                              color: CustomColors.whiteColor,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Visibility(
                                visible: selectedIndex == index,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 6.h),
                                  child: Text(
                                    selectedIndex == index ? changeDateFormat(message.createdAt.substring(0, 10)) : "",
                                    style: GoogleFonts.jost(fontSize: 12.sp),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    // controller.ticketStatus != "Closed" ?
                    MessageBar(
                      onSend: (text) async {
                        await controller.messageReply(text, controller.messageId, "1");
                        await controller.fetchTicketMessage(id);
                      },
                      messageBarColor: CustomColors.getBodyColor(),
                      sendButtonColor: CustomColors.primaryColor,
                      actions: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: CustomColors.getContainerColor(),
                                borderRadius: BorderRadius.circular(24.w),
                              ),
                              child: InkWell(
                                onTap: controller.pickFiles,
                                child: Icon(
                                  CupertinoIcons.link,
                                  color: CustomColors.primaryColor,
                                  size: 22,
                                ),
                              ),
                            ),
                            controller.selectedFiles.isNotEmpty
                                ? Positioned(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                                      decoration: BoxDecoration(
                                        color: CustomColors.primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        controller.selectedFiles.length.toString(),
                                        style: GoogleFonts.jost(
                                          fontSize: 12,
                                          color: CustomColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Text(""),
                          ],
                        ),
                      ],
                    )
                    // : const Text(""),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                    strokeWidth: 2.0,
                  ),
                ),
          // bottomNavigationBar: controller.ticketStatus == "Closed"
          //     ? BottomAppBar(
          //         height: 50.h,
          //         color: CustomColors.secondaryColor,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text(
          //               languageData["This ticket has been closed"] ?? "This ticket has been closed",
          //               textAlign: TextAlign.center,
          //               style: GoogleFonts.jost(color: CustomColors.whiteColor),
          //             ),
          //           ],
          //         ),
          //       )
          //     : BottomAppBar(height: 0.w),
        );
      },
    );
  }
}
