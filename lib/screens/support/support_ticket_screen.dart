import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/ticket_controller.dart';
import 'package:bill_payment/screens/support/create_ticket_screen.dart';
import 'package:bill_payment/screens/support/support_conversation.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/widgets/not_found.dart';
import 'package:bill_payment/widgets/shimmer_preloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SupportTicketScreen extends StatefulWidget {
  static const String routeName = "/supportTicketScreen";
  const SupportTicketScreen({super.key});

  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  final controller = Get.put(TicketController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    controller.fetchData();
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels == controller.scrollController.position.maxScrollExtent) {
        controller.loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    // controller.scrollController.dispose();
    Get.delete<TicketController>();
    super.dispose();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            controller.currentPage = 1;
            controller.isLoading = true;
            controller.ticketLists.clear();
          });
          await controller.fetchData();
        },
        color: CustomColors.primaryColor,
        child: Scaffold(
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
                                    Get.back();
                                  },
                                  icon: Icon(
                                    CupertinoIcons.back,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                                ),
                                Text(
                                  languageData["Support Ticket"] ?? "Support Ticket",
                                  style: GoogleFonts.jost(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  hoverColor: CustomColors.primaryColor,
                                  onPressed: () => Get.toNamed(CreateTicketScreen.routeName),
                                  icon: Icon(
                                    CupertinoIcons.pencil_circle_fill,
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
              Container(
                padding: EdgeInsets.only(top: 115.h),
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      controller.isLoading
                          ? Shimmer.fromColors(
                              baseColor: CustomColors.getContainerColor(),
                              highlightColor: CustomColors.getBodyColor(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 7, // Number of shimmer items
                                itemBuilder: (context, index) {
                                  return const ShimmerPreloader(); // Define ShimmerTransactionItem
                                },
                              ),
                            )
                          : controller.ticketLists.isNotEmpty
                              ? controller.isError
                                  ? NotFound(
                                      errorMessage: languageData["Error loading tickets. Please try again."] ??
                                          "Error loading tickets. Please try again.")
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: controller.ticketLists.length,
                                      itemBuilder: (context, index) {
                                        final item = controller.ticketLists[index];
                                        String imagePath = "assets/icon/open.png";
                                        if (item.status.toLowerCase() == "open") {
                                          imagePath = "assets/icon/open.png";
                                        } else if (item.status.toLowerCase() == "replied") {
                                          imagePath = "assets/icon/replied.png";
                                        } else if (item.status.toLowerCase() == "closed") {
                                          imagePath = "assets/icon/closed.png";
                                        } else if (item.status.toLowerCase() == "answered") {
                                          imagePath = "assets/icon/answered.png";
                                        }

                                        return GestureDetector(
                                          onTap: () => Get.toNamed(SupportConversationScreen.routeName,
                                              arguments: item.ticket.toString()),
                                          child: Container(
                                            margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.transparent,
                                                  blurRadius: 0,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 0),
                                                )
                                              ],
                                              borderRadius: BorderRadius.circular(16.w),
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.w),
                                                  child: Image.asset(
                                                    Get.isDarkMode
                                                        ? 'assets/ticket_bg_dark.png'
                                                        : 'assets/ticket_bg.png',
                                                    fit: BoxFit.cover,
                                                    height: 110,
                                                    width: double.infinity,
                                                  ),
                                                ),
                                                Positioned(
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                                                    leading: Image.asset(
                                                      imagePath,
                                                      fit: BoxFit.cover,
                                                      height: 48,
                                                      width: 48,
                                                    ),
                                                    horizontalTitleGap: 48.w,
                                                    minVerticalPadding: 15.h,
                                                    title: Container(
                                                      margin: EdgeInsets.only(bottom: 10.h),
                                                      child: Text(
                                                        "[${item.ticket}] ${item.subject}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.jost(
                                                          color: CustomColors.getTitleColor(),
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        Text(
                                                          "Last reply: ",
                                                          style: GoogleFonts.jost(
                                                            color: CustomColors.getTextColor(),
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          item.lastReply,
                                                          style: GoogleFonts.jost(
                                                            color: CustomColors.getTextColor(),
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w400,
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
                                      },
                                    )
                              : NotFound(errorMessage: languageData["No Tickets Available"] ?? "No Tickets Available"),
                      if (controller.currentPage < controller.lastPage)
                        Container(
                          height: 100, // Customize the loading indicator's height
                          padding: EdgeInsets.only(bottom: 25.h),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                            strokeWidth: 2.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: CustomColors.primaryColor,
            onPressed: () => Get.toNamed(CreateTicketScreen.routeName),
            child: const Icon(
              CupertinoIcons.add,
              color: CustomColors.whiteColor,
            ),
          ),
        ),
      );
    });
  }
}
