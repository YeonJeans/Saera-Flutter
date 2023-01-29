import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AccentLineChart extends StatefulWidget {
  const AccentLineChart({Key? key}) : super(key: key);

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


  List<double> x = [62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 83, 84, 85, 89, 90, 91, 94, 95, 96, 97, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 128, 129, 130, 131, 133, 134, 135, 136, 137, 138, 139, 140, 142, 143, 144, 145, 146];
  List<double> y = [0.4051089882850647, 0.41992107033729553, 0.42669838666915894, 0.4344402551651001, 0.44471898674964905, 0.45311856269836426, 0.46818867325782776, 0.4791885018348694, 0.48749542236328125, 0.48859041929244995, 0.48523277044296265, 0.4801586866378784, 0.49683672189712524, 0.488739013671875, 0.48026517033576965, 0.4789533317089081, 0.4772757589817047, 0.47632622718811035, 0.47546038031578064, 0.4814712107181549, 0.5193945169448853, 0.5280734896659851, 0.5259347558021545, 0.5644407272338867, 0.5512323379516602, 0.5414132475852966, 0.5546930432319641, 0.5427462458610535, 0.5419734120368958, 0.5414338111877441, 0.5256379246711731, 0.5138000845909119, 0.4997773766517639, 0.48972463607788086, 0.48228690028190613, 0.4922782778739929, 0.48204436898231506, 0.48171836137771606, 0.47427040338516235, 0.46321308612823486, 0.457002192735672, 0.4415334165096283, 0.43337249755859375, 0.4166470766067505, 0.39717280864715576, 0.3913012742996216, 0.3935408294200897, 0.3875139355659485, 0.38455989956855774, 0.38481178879737854, 0.38981011509895325, 0.39370742440223694, 0.3995702266693115, 0.4069574773311615, 0.4135153293609619, 0.4127331078052521, 0.39778563380241394, 0.39692893624305725, 0.3945861756801605, 0.38965386152267456, 0.4273936450481415, 0.41542497277259827, 0.3985927700996399, 0.3852178752422333, 0.37743011116981506, 0.373817503452301, 0.36990442872047424, 0.39090079069137573, 0.38694241642951965, 0.39080652594566345, 0.4026815593242645, 0.4118073582649231, 0.41539978981018066];


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
                double index = x[0];
                points.clear();

                for(int i = 0; i < x.length; i++){
                  points.add(AccentPoint(x[i], y[i]));
                  if(index != x[i]){
                    //print("here: ${index}");
                    points.add(AccentPoint(index, -1));
                    if(i+1 < x.length) {
                      index = x[i + 1];
                    }
                  }
                  else {
                    index+=1;
                  }
                }

                return points.map(
                        (point) => point.y != -1 ? FlSpot(point.x, point.y) : FlSpot.nullSpot
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
