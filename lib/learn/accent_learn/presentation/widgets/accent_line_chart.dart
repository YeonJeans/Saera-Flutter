
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/line_controller.dart';

class AccentLineChart extends StatefulWidget {
  const AccentLineChart({Key? key, required this.x, required this.y, required this.isRecord}) : super(key: key);

  final List<double> x;
  final List<double> y;

  final bool isRecord;

  @override
  State<AccentLineChart> createState() => _AccentLineChartState();
}

class AccentPoint {
  final double x;
  final double y;

  AccentPoint(this.x, this.y);
}

class _AccentLineChartState extends State<AccentLineChart> {

  final points = List<AccentPoint>.empty(growable: true);
  final LineController _lineManager = Get.find();

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
                  
                  points.add(AccentPoint(widget.x[0] - 1, 0.45));

                  bool isPass = false;

                  for(int i = 0; i < widget.x.length; i++){
                    if(!isPass && widget.y[i] == 0){
                      isPass = true;
                      continue;
                    }
                    points.add(AccentPoint(widget.x[i], widget.y[i]));
                  }

                  points.add(AccentPoint(widget.x[widget.x.length - 1] +1, 0.45));

                  return points.map(
                          (point) => point.y == 0 ? FlSpot.nullSpot :FlSpot(point.x, point.y)
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
                (){
              if(widget.isRecord){
                return Positioned(
                  left: width / _lineManager.rduration.value * _lineManager.rposition.value,
                  child: Container(
                    width: 1,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                  ),
                );
              }
              else{
                return Positioned(
                  left: width / _lineManager.duration.value * _lineManager.position.value,
                  child: Container(
                    width: 1,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                  ),
                );
              }
            }()

        ),

     ],
    );
  }
}
