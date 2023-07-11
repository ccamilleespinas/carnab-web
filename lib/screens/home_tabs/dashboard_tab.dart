import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sunspark_web/widgets/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool hasLoaded = false;

  int january = 0;

  int february = 0;

  int march = 0;

  int april = 0;

  int may = 0;

  int june = 0;

  int july = 0;

  int august = 0;

  int september = 0;

  int october = 0;

  int november = 0;

  int december = 0;

  getData() {
    FirebaseFirestore.instance
        .collection('Reports')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        if (doc['month'] == '1') {
          setState(() {
            january++;
          });
        } else if (doc['month'] == '2') {
          setState(() {
            february++;
          });
        } else if (doc['month'] == '3') {
          setState(() {
            march++;
          });
        } else if (doc['month'] == '4') {
          setState(() {
            april++;
          });
        } else if (doc['month'] == '5') {
          setState(() {
            may++;
          });
        } else if (doc['month'] == '6') {
          setState(() {
            june++;
          });
        } else if (doc['month'] == '7') {
          setState(() {
            july++;
          });
        } else if (doc['month'] == '8') {
          setState(() {
            august++;
          });
        } else if (doc['month'] == '9') {
          setState(() {
            september++;
          });
        } else if (doc['month'] == '10') {
          setState(() {
            october++;
          });
        } else if (doc['month'] == '11') {
          setState(() {
            november++;
          });
        } else if (doc['month'] == '12') {
          setState(() {
            december++;
          });
        }
      }
    }).then((value) {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(may);
    final List<SalesData> chartData = [
      SalesData(1, january.toDouble()),
      SalesData(2, february.toDouble()),
      SalesData(3, march.toDouble()),
      SalesData(4, april.toDouble()),
      SalesData(5, may.toDouble()),
      SalesData(6, june.toDouble()),
      SalesData(7, july.toDouble()),
      SalesData(8, august.toDouble()),
      SalesData(9, september.toDouble()),
      SalesData(10, october.toDouble()),
      SalesData(11, november.toDouble()),
      SalesData(12, december.toDouble()),
    ];
    return hasLoaded
        ? Padding(
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
                                text: 'Total Officers',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Officers')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return const Center(child: Text('Error'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      print('waiting');
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.black,
                                        )),
                                      );
                                    }

                                    final data = snapshot.requireData;
                                    return TextBold(
                                      text: data.docs.length.toString(),
                                      fontSize: 58,
                                      color: Colors.black,
                                    );
                                  }),
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
                                text: 'Total Users',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Users')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return const Center(child: Text('Error'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      print('waiting');
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.black,
                                        )),
                                      );
                                    }

                                    final data = snapshot.requireData;
                                    return TextBold(
                                      text: data.docs.length.toString(),
                                      fontSize: 58,
                                      color: Colors.black,
                                    );
                                  }),
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
                                text: 'Total Reports',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Reports')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return const Center(child: Text('Error'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      print('waiting');
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.black,
                                        )),
                                      );
                                    }

                                    final data = snapshot.requireData;
                                    return TextBold(
                                      text: data.docs.length.toString(),
                                      fontSize: 58,
                                      color: Colors.black,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
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
          )
        : const Center(
            child: CircularProgressIndicator(),
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
