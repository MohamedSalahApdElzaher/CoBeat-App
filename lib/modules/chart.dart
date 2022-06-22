import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:covid/config/styles.dart';

class CovidBarChart extends StatelessWidget {

   List<dynamic> covidCases, date;

    CovidBarChart({ required this.covidCases, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),

      child: Column(
        children: <Widget>[

          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 20, top: 20,bottom: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Global Cases',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 16.0,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    margin: 10.0,
                    showTitles: true,
                    textStyle: Styles.chartLabelsTextStyle,
                    rotateAngle: 35.0,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return date[0].toString();
                        case 1:
                          return date[1].toString();
                        case 2:
                          return date[2].toString();
                        case 3:
                          return date[3].toString();
                        case 4:
                          return date[4].toString();
                        case 5:
                          return date[5].toString();
                        case 6:
                          return date[6].toString();
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                      margin: 20.0,
                      showTitles: true,
                      textStyle: Styles.chartLabelsTextStyle,
                      getTitles: (value) {
                        if (value == 0) {
                          return '0';
                        } else if (value % 1 == 0) {
                          return '${value ~/ 1 * 45}M';
                        }
                        return '';
                      }),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 3 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.black12,
                    strokeWidth: 1.0,
                    dashArray: [5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: covidCases
                    .asMap()
                    .map((key, value) => MapEntry(
                    key,
                    BarChartGroupData(
                      x: key,
                      barRods: [
                        BarChartRodData(
                          y: value,
                          color: Colors.red,
                        ),
                      ],
                    )))
                    .values
                    .toList(),
              ),
            ),
          ),

        ],
      ),

    );
  }
}
