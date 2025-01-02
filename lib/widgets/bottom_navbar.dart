import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:bill_payment/controller/pusher_controller.dart';
import 'package:bill_payment/screens/bill/bill_request_screen.dart';
import 'package:bill_payment/screens/home_screen.dart';
import 'package:bill_payment/screens/bill/billpay_screen.dart';
import 'package:bill_payment/screens/bill/pay_list_screen.dart';
import 'package:bill_payment/screens/transaction_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = "/bottomNavbar";
  final int selectedIndex;
  const BottomNavBar({super.key, required this.selectedIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final pusherController = Get.put(PusherController());
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const PayListScreen(),
    const BillRequestScreen(),
    const TransactionScreen(),
    const BillPayScreen(),
  ];

  Future<void> connectPusherChannel() async {
    await pusherController.fetchPusherConfig();
    pusherController.onConnectPressed();
  }

  @override
  void initState() {
    _currentIndex = widget.selectedIndex;
    connectPusherChannel();
    // pusherController.triggerEventAutomatically();
    super.initState();
  }

  final List<IconData> iconList = [
    CupertinoIcons.home,
    CupertinoIcons.list_bullet,
    Icons.request_page_outlined,
    CupertinoIcons.arrow_right_arrow_left,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _currentIndex = 4;
            });
          },
          backgroundColor: CustomColors.primaryColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: const Icon(
              CupertinoIcons.paperplane,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: CustomColors.getContainerColor(),
        itemCount: iconList.length,
        height: 70,
        tabBuilder: (int index, bool isActive) {
          return Icon(
            iconList[index],
            size: 24,
            color: isActive ? CustomColors.primaryColor : CustomColors.getTextColor(),
          );
        },
        leftCornerRadius: 10,
        rightCornerRadius: 10,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
