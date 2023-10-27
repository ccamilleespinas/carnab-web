import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sunspark_web/model/reports_model.dart';
import '../../widgets/text_widget.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  @override
  void initState() {
    getCrimes();
    super.initState();
  }

  List<Report> reportsList = <Report>[];

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  getCrimes() async {
    try {
      List data = [];
      var result = await FirebaseFirestore.instance.collection('Reports').get();
      var reports = result.docs;
      for (var i = 0; i < reports.length; i++) {
        Map mapData = reports[i].data();
        if (mapData.containsKey('police_taked_action')) {
          mapData['date_taken'] = reports[i]['date_taken'].toDate().toString();
          mapData['police_name'] = reports[i]['police_name'];
          mapData.remove('police_taked_action');
        }
        mapData['dateAndTime'] = reports[i]['dateAndTime'].toDate().toString();
        mapData['dateTime'] = reports[i]['dateTime'].toDate().toString();
        data.add(mapData);
      }

      setState(() {
        reportsList = reportFromJson(jsonEncode(data));
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 50, 20),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextBold(
                text: 'Analytics',
                fontSize: 24,
                color: Colors.black,
              ),
              const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Container(
                  height: 125,
                  width: 275,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'Total Resolved',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Reports')
                                .where('status', isEqualTo: 'Resolved')
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
              ),
              const SizedBox(
                width: 20,
              ),
              Card(
                elevation: 5,
                child: Container(
                  height: 125,
                  width: 275,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'Total Unresolved',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Reports')
                                .where('status', isEqualTo: 'Unresolved')
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
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Container(
                  height: 125,
                  width: 275,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          text: 'Total Processing',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Reports')
                                .where('status', isEqualTo: 'Processing')
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
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextRegular(
            text: 'Crime Hotspot',
            fontSize: 18,
            color: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Reports').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                return Card(
                  elevation: 5,
                  child: Container(
                    height: 400,
                    width: 800,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: 425,
                          child: FlutterMap(
                            options: MapOptions(
                              center: LatLng(13.401972, 123.345909),
                              zoom: 12.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              CircleLayer(
                                circles: [
                                  for (int i = 0; i < data.docs.length; i++)
                                    CircleMarker(
                                      color: Colors.red.withOpacity(0.3),
                                      point: LatLng(data.docs[i]['lat'],
                                          data.docs[i]['long']),
                                      radius: 20,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                );
              }),
          SizedBox(
            height: getHeight(3),
          ),
          TextRegular(
            text: 'Crimes',
            fontSize: 18,
            color: Colors.black,
          ),
          SizedBox(
            height: getHeight(2),
          ),
          SizedBox(
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: getHeight(2),
                        bottom: getHeight(2),
                        left: getWidth(2),
                        right: getWidth(2)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: getWidth(8),
                          child: TextBold(
                            text: 'Crime Type',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: getWidth(10),
                          child: TextBold(
                            text: 'Reported by',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: getWidth(9),
                          child: TextBold(
                            text: 'Contact no',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: getWidth(17),
                          child: TextBold(
                            text: 'Address',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: getWidth(15),
                          child: TextBold(
                            text: 'Response date & time',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: getWidth(8),
                          child: TextBold(
                            text: 'Status',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: getHeight(2),
                        bottom: getHeight(2),
                        left: getWidth(2),
                        right: getWidth(2)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reportsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(top: getHeight(2)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: getWidth(8),
                                      child: Text(reportsList[index].type)),
                                  SizedBox(
                                    width: getWidth(10),
                                    child: Text(reportsList[index].name),
                                  ),
                                  SizedBox(
                                      width: getWidth(9),
                                      child: Text(
                                          reportsList[index].contactNumber)),
                                  SizedBox(
                                      width: getWidth(17),
                                      child: Text(reportsList[index].address)),
                                  SizedBox(
                                    width: getWidth(15),
                                    child: Text(
                                      reportsList[index].dateTaken == null
                                          ? ""
                                          : "${DateFormat.yMMMd().format(reportsList[index].dateTaken!)}  ${DateFormat.jm().format(reportsList[index].dateTaken!)}",
                                    ),
                                  ),
                                  SizedBox(
                                    width: getWidth(8),
                                    child: Text(
                                      reportsList[index].status,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: reportsList[index].status ==
                                                  "Unresolved"
                                              ? Colors.red
                                              : reportsList[index].status ==
                                                      "Processing"
                                                  ? Colors.orange
                                                  : Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: getHeight(5),
          ),
        ])));
  }
}
