import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/line_controller.dart';

class AccentLineChart extends StatefulWidget {
  const AccentLineChart({Key? key, required this.x, required this.y}) : super(key: key);

  final List<double> x;
  final List<double> y;

  // 전체 시간과 line 플레이 여부를 받아오기

  @override
  State<AccentLineChart> createState() => _AccentLineChartState();
}

class AccentPoint {
  final double x;
  final double y;

  AccentPoint(this.x, this.y);
}

class _AccentLineChartState extends State<AccentLineChart> {

  final points = new List<AccentPoint>.empty(growable: true);
  final LineController _lineManager = Get.find();

  bool isPlay = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        LineChart(
          LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              gridData: FlGridData(
                show: false,
                drawVerticalLine: false,
                drawHorizontalLine: false,
              ),
              titlesData: FlTitlesData(
                show: false,
              ),

              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(spots: (){
                  points.clear();

                  for(int i = 0; i < widget.x.length; i++){
                    points.add(AccentPoint(widget.x[i], widget.y[i]));
                  }

                  return points.map(
                          (point) => FlSpot(point.x, point.y)
                  ).toList();
                }(),
                  color: Colors.black,
                  dotData: FlDotData(
                    show: false,
                  ),
                )
              ]),
        ),

        //이곳에 라인 지나가도록 추가
        Obx(() =>
            Positioned(
              left: width / _lineManager.duration.value * _lineManager.position.value,
              child: Container(
                width: 1,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              ),
            ),
        ),

     ],
    );
  }
}
