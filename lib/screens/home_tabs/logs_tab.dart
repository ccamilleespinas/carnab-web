import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/text_widget.dart';

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<LogsTab> {
  List logsList = [];
  List logsListMasterList = [];
  Timer? _debounce;
  TextEditingController searchController = TextEditingController();
  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  getLogs() async {
    var res = await FirebaseFirestore.instance
        .collection('logs')
        .orderBy('dateTime', descending: true)
        .get();
    var logs = res.docs;
    List tempData = [];
    List tempDataTwo = [];
    for (var i = 0; i < logs.length; i++) {
      Map mapData = logs[i].data();
      mapData['id'] = logs[i].id;
      mapData['dateTime'] =
          "${DateFormat.yMMMMd().format(DateTime.parse(mapData['dateTime'].toDate().toString()))} ${DateFormat.jm().format(DateTime.parse(mapData['dateTime'].toDate().toString()))}";
      tempData.add(mapData);
      tempDataTwo.add(mapData);
    }
    setState(() {
      logsList = tempData;
      logsListMasterList = tempDataTwo;
    });
  }

  searchLogs({required String keyword}) async {
    logsList.clear();
    for (var i = 0; i < logsListMasterList.length; i++) {
      if (logsListMasterList[i]['username']
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase().toString()) ||
          logsListMasterList[i]['logMessage']
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase().toString())) {
        logsList.add(logsListMasterList[i]);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getLogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 50, 20),
        child: SizedBox(
          height: getHeight(100),
          width: getWidth(100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBold(
                    text: 'Logs',
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1500), () {
                          if (value.isEmpty) {
                            getLogs();
                          } else {
                            searchLogs(keyword: value);
                          }
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search Logs',
                          hintStyle: TextStyle(fontFamily: 'QRegular'),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                      controller: searchController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getHeight(3),
              ),
              Expanded(
                  child: SizedBox(
                width: getWidth(100),
                child: DataTable(columns: const [
                  DataColumn(
                    label: Expanded(
                        child: Text(
                      'User',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "QBold"),
                    )),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Expanded(
                        child: Text(
                      'Logs',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "QBold"),
                    )),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Expanded(
                        child: Text(
                      'Date',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "QBold"),
                    )),
                    numeric: false,
                  ),
                ], rows: [
                  for (var i = 0; i < logsList.length; i++) ...[
                    DataRow(cells: <DataCell>[
                      DataCell(Expanded(child: Text(logsList[i]['username']))),
                      DataCell(
                          Expanded(child: Text(logsList[i]['logMessage']))),
                      DataCell(Expanded(child: Text(logsList[i]['dateTime']))),
                    ])
                  ]
                ]),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
