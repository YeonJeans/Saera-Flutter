
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../style/color.dart';
import '../../data/line_controller.dart';

class AccentLineChart extends StatefulWidget {
  const AccentLineChart({Key? key, required this.x, required this.y, required this.isRecord, required this.isStandard}) : super(key: key);

  final List<double> x;
  final List<double> y;

  final bool isRecord;
  final bool isStandard;

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

                  if(widget.isRecord){
                    points.add(AccentPoint(0, 0.45));

                    for(int i = 4; i < widget.x[0]; i++){
                      points.add(AccentPoint(i + 0.0, 0));
                    }

                    for(int i = 0; i < widget.x.length; i++){
                      points.add(AccentPoint(widget.x[i], widget.y[i]));
                    }
                  }
                  else{
                    for(int i = 0; i < widget.x.length; i++){
                      points.add(AccentPoint(widget.x[i], widget.y[i]));
                    }
                  }

                  return points.map(
                          (point) => point.y == 0 ? FlSpot.nullSpot :FlSpot(point.x, point.y)
                  ).toList();
                }(),
                  color: widget.isStandard ? ColorStyles.saeraRed.withOpacity(0.3) : Colors.black,
                  dotData: FlDotData(
                    show: false,
                  ),
                )
              ]),
        ),

        //이곳에 라인 지나가도록 추가
        Obx(() =>
                (){
              if(widget.isRecord && !widget.isStandard){
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
              else if(!widget.isStandard){
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
              else{
                return Positioned(
                  left: _lineManager.position.value,
                  child: Container(
                    width: 1,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
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
