import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<LogsTab> {
  List logsList = [];
  List logsListMasterList = [];
  Timer? _debounce;

  DateTime? initialDate;
  DateTime? endDate;

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

  filterData() async {
    if (initialDate != null && endDate != null) {
      logsList.clear();
      for (var i = 0; i < logsListMasterList.length; i++) {
        if (DateTime.parse(
                    logsListMasterList[i]['dateTime'].toDate().toString())
                .isAfter(initialDate!) &&
            DateTime.parse(
                    logsListMasterList[i]['dateTime'].toDate().toString())
                .isBefore(endDate!)) {
          logsList.add(logsListMasterList[i]);
        }
      }
    }
  }

  getCalendarFrom() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      setState(() {
        initialDate = pickedDate;
        filterData();
      });
    }
  }

  getCalendarTo() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
        filterData();
      });
    }
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
          child: SingleChildScrollView(
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
                    TextRegular(
                        text: "From:", fontSize: 15, color: Colors.black),
                    InkWell(
                      onTap: () {
                        getCalendarFrom();
                      },
                      child: initialDate == null
                          ? const Icon(Icons.calendar_month)
                          : TextRegular(
                              text: DateFormat.yMMMd().format(initialDate!),
                              fontSize: 15,
                              color: Colors.black),
                    ),
                    TextRegular(text: "To:", fontSize: 15, color: Colors.black),
                    InkWell(
                      onTap: () {
                        getCalendarTo();
                      },
                      child: endDate == null
                          ? const Icon(Icons.calendar_month)
                          : TextRegular(
                              text: DateFormat.yMMMd().format(endDate!),
                              fontSize: 15,
                              color: Colors.black),
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
                    IconButton(
                        onPressed: () {
                          setState(() {
                            initialDate = null;
                            endDate = null;
                            logsList.addAll(logsListMasterList);
                          });
                        },
                        icon: const Icon(Icons.clear)),
                  ],
                ),
                SizedBox(
                  height: getHeight(3),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    child: Table(
                      // textDirection: TextDirection.ltr,
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(width: 1, color: Colors.black),
                      children: [
                        TableRow(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextBold(
                                text: "User",
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextBold(
                                text: "Logs",
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextBold(
                                text: "Date/Time",
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          SizedBox(
                            height: getHeight(3),
                          ),
                          SizedBox(
                            height: getHeight(3),
                          ),
                          SizedBox(
                            height: getHeight(3),
                          ),
                        ]),
                        for (var i = 0; i < logsList.length; i++) ...[
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                logsList[i]['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                logsList[i]['logMessage'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${DateFormat.yMMMMd().format(DateTime.parse(logsList[i]['dateTime'].toDate().toString()))} ${DateFormat.jm().format(DateTime.parse(logsList[i]['dateTime'].toDate().toString()))}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                            ),
                          ]),
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
