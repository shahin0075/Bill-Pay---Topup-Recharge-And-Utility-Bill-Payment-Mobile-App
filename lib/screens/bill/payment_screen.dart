import 'package:bill_payment/controller/bill_category_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/payment_controller.dart';
import 'package:bill_payment/screens/bill/card_payment_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = "/paymentScreen";
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.put(BillPayController());
  final sdkPaymentHandle = Get.put(SdkPaymentHandle());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  TextEditingController searchController = TextEditingController();

  void onSearchTextChanged(String text) {
    setState(() {
      // Filter the gateways based on the search text
      if (controller.paymentPreview != null) {
        controller.filteredGateways = controller.paymentPreview!.gateways.where((gateway) {
          return gateway.name.toLowerCase().contains(text.toLowerCase());
        }).toList();
      }
    });
  }

  bool _isClicked = false;
  void startLoading() {
    setState(() {
      _isClicked = true;
    });
    // Simulate loading for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isClicked = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    controller.fetchPaymentMethods(controller.utr);
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPayController>(builder: (controller) {
      return Scaffold(
        backgroundColor: CustomColors.getBodyColor(),
        body: controller.paymentPreview != null
            ? SingleChildScrollView(
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
                            height: 200,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            margin: EdgeInsets.only(top: 60.h),
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      hoverColor: CustomColors.primaryColor,
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
                                      languageData["Payment Method"] ?? "Payment Method",
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
                                        CupertinoIcons.bell,
                                        color: Colors.white,
                                        size: 0.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                                  decoration: BoxDecoration(
                                    color: CustomColors.getContainerColor(),
                                    borderRadius: BorderRadius.circular(16.w),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomColors.getShadowColor(),
                                        offset: const Offset(0, 4),
                                        blurRadius: 3,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 10.h),
                                            child: Text(
                                              languageData["Select Payment Method"] ?? "Select Payment Method",
                                              style: GoogleFonts.jost(
                                                color: CustomColors.getTitleColor(),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            child: TextFormField(
                                              controller: searchController,
                                              onChanged: onSearchTextChanged,
                                              style: GoogleFonts.getFont(
                                                'Jost',
                                                textStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              decoration: InputDecoration(
                                                hintText: languageData["Search"] ?? "Search",
                                                hintStyle: GoogleFonts.jost(
                                                  color: CustomColors.getTextColor(),
                                                ),
                                                suffixIconConstraints: BoxConstraints(maxWidth: 30.w, minWidth: 30.w),
                                                suffixIcon: Icon(
                                                  CupertinoIcons.search,
                                                  size: 18.sp,
                                                  color: CustomColors.getTextColor(),
                                                ),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8.w),
                                                  borderSide: BorderSide(
                                                    color: CustomColors.getBorderColor(), // Change the color as needed
                                                    width: 1.w,
                                                  ),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8.w),
                                                  borderSide: BorderSide(
                                                    color: CustomColors.primaryColor,
                                                    width: 1.w,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      SizedBox(
                                        height: 70.h,
                                        child: controller.filteredGateways.isNotEmpty
                                            ? ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                // itemCount: controller.paymentPreview!.gateways.length,
                                                itemCount: controller.filteredGateways.length,
                                                itemBuilder: (context, index) {
                                                  // var gateway = controller.paymentPreview!.gateways[index];
                                                  var gateway = controller.filteredGateways[index];
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        controller.selectedGateway = gateway;
                                                        sdkPaymentHandle.gatewayId = gateway.id
                                                            .toString(); // saving gatewayId for sdk payment handle
                                                        controller.storeGatewayParameters();
                                                        controller.calculatePayableAmount(
                                                          double.parse(controller.paymentPreview!.amount.toString()),
                                                          double.parse(controller.paymentPreview!.charge.toString()),
                                                          double.parse(
                                                              controller.paymentPreview!.exchangeRate.toString()),
                                                          double.parse(
                                                              controller.selectedGateway!.fixedCharge.toString()),
                                                          double.parse(
                                                              controller.selectedGateway!.percentageCharge.toString()),
                                                        );
                                                      });
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: 5.w),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: 100.w,
                                                            height: 60.h,
                                                            padding: EdgeInsets.all(4.w),
                                                            decoration: BoxDecoration(
                                                              color: CustomColors.getContainerColor(),
                                                              borderRadius: BorderRadius.circular(8.w),
                                                              border: Border.all(
                                                                color: controller.selectedGateway == gateway
                                                                    ? CustomColors.primaryColor
                                                                    : CustomColors.getBorderColor(),
                                                                width: 2.w,
                                                              ),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(6.w),
                                                              child: Image.network(
                                                                gateway.imagePath,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child: Text("No Gateways Found!"),
                                              ),
                                      ),
                                      controller.selectedGateway != null && controller.selectedGateway!.id > 999
                                          ? Form(
                                              key: _formKey,
                                              child: Column(
                                                children: [
                                                  for (var entry in controller.selectedGateway!.parameters.entries)
                                                    buildFormField(entry.key, entry.value['field_level']),
                                                  SizedBox(height: 8.h),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (_formKey.currentState!.validate()) {
                                                        controller
                                                            .submitManualPayment(); // TODO: Nid field must be file
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: CustomColors.primaryColor,
                                                      ),
                                                      child: !controller.isLoading
                                                          ? Text(languageData["Continue"] ?? "Continue",
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.jost(
                                                                color: Colors.white,
                                                                fontSize: 16.sp,
                                                              ))
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
                                            )
                                          : const SizedBox(height: 0),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: CustomColors.getContainerColor(),
                                    borderRadius: BorderRadius.circular(10.w),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomColors.getShadowColor(),
                                        offset: const Offset(0, 4),
                                        blurRadius: 3,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        languageData["Payment Preview"] ?? "Payment Preview",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.getTitleColor(),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languageData["Category"] ?? "Category",
                                            style: GoogleFonts.jost(
                                              color: CustomColors.getTitleColor(),
                                            ),
                                          ),
                                          Text(controller
                                              .capitalizeEachWord(controller.paymentPreview!.category.toLowerCase())),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              languageData["Service"] ?? "Service",
                                              style: GoogleFonts.jost(
                                                color: CustomColors.getTitleColor(),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(controller.paymentPreview!.service),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languageData["Amount"] ?? "Amount",
                                            style: GoogleFonts.jost(
                                              color: CustomColors.getTitleColor(),
                                            ),
                                          ),
                                          Text(
                                              "${double.parse(controller.paymentPreview!.amount.toString())} ${controller.paymentPreview!.currency}"),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languageData["Charge"] ?? "Charge",
                                            style: GoogleFonts.jost(
                                              color: CustomColors.orangeColor,
                                            ),
                                          ),
                                          Text(
                                              "${controller.paymentPreview!.charge.toString()} ${controller.paymentPreview!.currency}"),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      if (controller.selectedGateway != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  languageData["Payable Amount"] ?? "Payable Amount",
                                                  style: GoogleFonts.jost(
                                                    color: CustomColors.getTitleColor(),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${double.parse(controller.totalPayableAmount.toString()).toStringAsFixed(2)} USD",
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16.h),
                                            controller.selectedGateway != null && controller.selectedGateway!.id < 1000
                                                ? GestureDetector(
                                                    onTap: _isClicked == true
                                                        ? null
                                                        : () {
                                                            startLoading();
                                                            // wallet payment
                                                            if (controller.selectedGateway!.id == 00) {
                                                              controller.submitWalletPayment();
                                                            }
                                                            // stripe
                                                            else if (controller.selectedGateway!.id == 2) {
                                                              sdkPaymentHandle.stripeMakePayment(
                                                                  amount: controller.totalPayableAmount.toString());
                                                            }
                                                            // razorpay
                                                            else if (controller.selectedGateway!.id == 10) {
                                                              sdkPaymentHandle.razorpayMakePayment(
                                                                  amount: controller.totalPayableAmount.toString());
                                                            }
                                                            // flutterwave
                                                            else if (controller.selectedGateway!.id == 9) {
                                                              sdkPaymentHandle.flutterwaveMakePayment(
                                                                  amount: controller.totalPayableAmount.toString());
                                                            }
                                                            // monnify
                                                            else if (controller.selectedGateway!.id == 20) {
                                                              sdkPaymentHandle.monnifyMakePayment(
                                                                  amount: controller.totalPayableAmount!.toDouble());
                                                            }
                                                            // paytm
                                                            else if (controller.selectedGateway!.id == 5) {
                                                              sdkPaymentHandle.paytmMakePayment(
                                                                  amount: controller.totalPayableAmount!.toString());
                                                            }
                                                            // paypal
                                                            else if (controller.selectedGateway!.id == 1) {
                                                              sdkPaymentHandle.paypalMakePayment(
                                                                  amount: controller.totalPayableAmount!.toString());
                                                            }
                                                            // paystack
                                                            else if (controller.selectedGateway!.id == 7) {
                                                              sdkPaymentHandle.paystackMakePayment(context,
                                                                  amount: controller.totalPayableAmount!.toDouble());
                                                            }
                                                            // card payment
                                                            else if (controller.selectedGateway!.id == 14 ||
                                                                controller.selectedGateway!.id == 15) {
                                                              Get.toNamed(CardPaymentScreen.routeName);
                                                            }
                                                            // automatic payment
                                                            else {
                                                              controller.submitAutomaticPayment();
                                                            }
                                                          },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: CustomColors.primaryColor,
                                                      ),
                                                      child: !_isClicked
                                                          ? Text(languageData["Pay"] ?? "Pay",
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.jost(
                                                                color: Colors.white,
                                                                fontSize: 16.sp,
                                                              ))
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
                                                    ))
                                                : SizedBox(height: 0.h),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                  strokeWidth: 2.0,
                ),
              ),
      );
    });
  }

  Widget buildFormField(dynamic fieldKey, dynamic fieldName) {
    TextEditingController? inputController = controller.manualPaymentParameters[fieldKey];

    return Column(
      children: [
        fieldName != "NID"
            ? Container(
                margin: EdgeInsets.only(bottom: 8.h, top: 8.h),
                child: TextFormField(
                  controller: inputController,
                  keyboardType: fieldName.toLowerCase().contains("number") ? TextInputType.number : TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return languageData['This field can not be empty'] ?? 'This field can not be empty';
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
                    labelText: fieldName,
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
                    errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                    filled: true,
                    fillColor: CustomColors.getInputColor(),
                  ),
                ),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}
