import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AccentLineChart extends StatefulWidget {
  const AccentLineChart({Key? key, required this.x, required this.y}) : super(key: key);

  final List<double> x;
  final List<double> y;

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

  // List<double> x =
  // List<double> y =
  @override
  Widget build(BuildContext context) {
    return LineChart(
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

    );
  }
}
