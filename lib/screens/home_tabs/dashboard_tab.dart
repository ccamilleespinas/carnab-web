import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sunspark_web/widgets/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardTab extends StatelessWidget {
  DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData(10, 35),
      SalesData(11, 28),
      SalesData(12, 34),
      SalesData(13, 32),
      SalesData(14, 40)
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 125,
                  width: 275,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'Title here',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        TextBold(
                          text: '100',
                          fontSize: 58,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 125,
                  width: 275,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'Title here',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        TextBold(
                          text: '100',
                          fontSize: 58,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 125,
                  width: 275,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'Title here',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        TextBold(
                          text: '100',
                          fontSize: 58,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 125,
                  width: 275,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'Title here',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        TextBold(
                          text: '100',
                          fontSize: 58,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  width: 500,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SfCartesianChart(series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<SalesData, int>(
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales)
                  ]),
                ),
                const SizedBox(
                  width: 40,
                ),
                PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: 150,

                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "HYBRID",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };
}

class SalesData {
  SalesData(this.year, this.sales);
  final int year;
  final double sales;
}
