import 'package:bill_payment/controller/profile_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BillStatistics extends StatefulWidget {
  const BillStatistics({super.key});

  @override
  State<BillStatistics> createState() => _BillStatisticsState();
}

class _BillStatisticsState extends State<BillStatistics> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  dynamic maximumHeight;

  final profileController = Get.put(ProfileController());

  void storeStatistics() {
    final int startIndex = profileController.monthLabels.length - 6;
    final lastSixData = startIndex >= 0
        ? List<_ChartData>.generate(
            6,
            (index) => _ChartData(
              profileController.monthLabels[startIndex + index].substring(0, 3),
              profileController.yearCompleteBills[startIndex + index].toDouble(),
            ),
          )
        : List<_ChartData>.generate(
            profileController.monthLabels.length,
            (index) => _ChartData(
              profileController.monthLabels[index].substring(0, 3),
              profileController.yearCompleteBills[index].toDouble(),
            ),
          );

    maximumHeight =
        profileController.yearCompleteBills.reduce((value, element) => value > element ? value : element) + 1;
    data = lastSixData;
  }

  @override
  void initState() {
    storeStatistics();

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: GoogleFonts.jost(
          fontSize: 0,
          color: Colors.transparent,
        ),
        opposedPosition: false,
        majorGridLines: MajorGridLines(width: 0.w),
        majorTickLines: MajorTickLines(size: 0.sp),
        axisLine: AxisLine(width: 0.w),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: maximumHeight.toDouble(),
        interval: 5,
        labelStyle: GoogleFonts.jost(
          fontSize: 0,
          color: Colors.transparent,
        ),
        opposedPosition: false,
        majorGridLines: MajorGridLines(width: 0.w),
        majorTickLines: MajorTickLines(size: 0.sp),
        axisLine: AxisLine(width: 0.w),
      ),
      tooltipBehavior: _tooltip,
      series: <ChartSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          name: 'Pay Bill',
          color: CustomColors.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.w),
            topRight: Radius.circular(10.w),
            bottomLeft: Radius.circular(10.w),
            bottomRight: Radius.circular(10.w),
          ),
          width: 0.4.w,
        )
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
