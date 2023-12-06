import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;
import '../../model/reports_model.dart';
import '../../widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  String nameSearched = '';
  List<Report> reportsList = <Report>[];
  List<Report> reportsListMasterList = <Report>[];

  DateTime? initialDate;
  DateTime? endDate;

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  getReports() async {
    List data = [];
    var result = await FirebaseFirestore.instance
        .collection('Reports')
        .orderBy('dateTime', descending: true)
        .get();
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
      reportsListMasterList = reportFromJson(jsonEncode(data));
    });
  }

  searchReport({required String word}) async {
    reportsList.clear();
    if (word.isEmpty || word.trim() == "") {
      reportsList.addAll(reportsListMasterList);
    } else {
      if (word.toLowerCase().toString() == "resolved" ||
          word.toLowerCase().toString() == "resolved") {
        for (var i = 0; i < reportsListMasterList.length; i++) {
          if (reportsListMasterList[i].status.toLowerCase().toString() ==
              word.toLowerCase().toString()) {
            reportsList.add(reportsListMasterList[i]);
          }
        }
      } else {
        for (var i = 0; i < reportsListMasterList.length; i++) {
          if (reportsListMasterList[i]
                  .name
                  .toLowerCase()
                  .toString()
                  .contains(word.toLowerCase().toString()) ||
              reportsListMasterList[i]
                  .address
                  .toLowerCase()
                  .toString()
                  .contains(word.toLowerCase().toString()) ||
              reportsListMasterList[i]
                  .type
                  .toLowerCase()
                  .toString()
                  .contains(word.toLowerCase().toString()) ||
              reportsListMasterList[i]
                  .status
                  .toLowerCase()
                  .toString()
                  .contains(word.toLowerCase().toString())) {
            reportsList.add(reportsListMasterList[i]);
          }
        }
      }
    }
  }

  filterData() async {
    if (initialDate != null && endDate != null) {
      reportsList.clear();
      for (var i = 0; i < reportsListMasterList.length; i++) {
        if (reportsListMasterList[i].dateAndTime.isAfter(initialDate!) &&
            reportsListMasterList[i].dateAndTime.isBefore(endDate!)) {
          reportsList.add(reportsListMasterList[i]);
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

  Future<void> createPdf() async {
    final Uint8List headerImage =
        (await rootBundle.load("assets/images/carnab.png"))
            .buffer
            .asUint8List();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        pageFormat: PdfPageFormat.a4,
        // build: (pw.Context context) => widget,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Row(children: [
              pw.Container(
                height: 50,
                width: 50,
                child: pw.Image(
                  pw.MemoryImage(
                    headerImage,
                  ),
                  fit: pw.BoxFit.cover,
                ),
              ),
              pw.SizedBox(width: 4.0),
              pw.Text("CARNab - Crime and Accident Reporting System of Nabua",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  )),
            ]),
            pw.Divider(),
            pw.SizedBox(height: 24.0),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Report",
                  ),
                  pw.Text(DateFormat.yMMMMd().format(DateTime.now())),
                ]),
            pw.Table(border: pw.TableBorder.all(), children: [
              // Header row
              pw.TableRow(children: [
                pw.Center(child: pw.Text("Reporter")),
                pw.Center(child: pw.Text("Incident")),
                pw.Center(child: pw.Text("Date & Time")),
                pw.Center(child: pw.Text("Location")),
                pw.Center(child: pw.Text("Police taked action")),
                pw.Center(child: pw.Text("Status")),
              ]),
              //  Data rows
              for (var i = 0; i < reportsList.length; i++)
                pw.TableRow(children: [
                  pw.Center(child: pw.Text(reportsList[i].name.toString())),
                  pw.Center(child: pw.Text(reportsList[i].type.toString())),
                  pw.Center(
                      child: pw.Text(
                    ("${DateFormat.yMMMd().format(reportsList[i].dateTime)}  ${DateFormat.jm().format(reportsList[i].dateTime)}")
                        .toString(),
                  )),
                  pw.Center(
                      child: pw.Text(
                    ("${reportsList[i].address} ").toString(),
                  )),
                  pw.Center(
                      child: pw.Text(
                    reportsList[i].policeName == null
                        ? "".toString()
                        : reportsList[i].policeName!.toString(),
                  )),
                  pw.Center(child: pw.Text(reportsList[i].status.toString())),
                ]),

              // // Data rows
            ]),
          ];
        },
      ),
    );

    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);

    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute("download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
      ..click();
    await FirebaseFirestore.instance.collection('logs').add({
      "dateTime": Timestamp.now(),
      "username": "Admin",
      "userid": "Admin",
      "userDocReference": "",
      "logMessage": "Generated a report for report management"
    });
  }

  @override
  void initState() {
    getReports();
    super.initState();
  }

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 50, 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBold(
                  text: 'Reports Management',
                  fontSize: 24,
                  color: Colors.black,
                ),
                TextRegular(text: "From:", fontSize: 15, color: Colors.black),
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
                      setState(() {
                        searchReport(word: value.toString());
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search Report',
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
                        reportsList.addAll(reportsListMasterList);
                      });
                    },
                    icon: const Icon(Icons.clear)),
                IconButton(
                    onPressed: () {
                      createPdf();
                    },
                    icon: const Icon(Icons.file_download_sharp))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Table(
                textDirection: TextDirection.ltr,
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(width: 1, color: Colors.black),
                children: [
                  TableRow(children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextBold(
                          text: "Name of the Reporter",
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
                          text: "Type of Incident",
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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextBold(
                          text: "Location",
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
                          text: "Statement",
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
                          text: "Name of the Police that take action",
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
                          text: "Status",
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
                          text: "Actions",
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
                    SizedBox(
                      height: getHeight(3),
                    ),
                    SizedBox(
                      height: getHeight(3),
                    ),
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
                  for (var i = 0; i < reportsList.length; i++) ...[
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          reportsList[i].name,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          reportsList[i].type,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${DateFormat.yMMMd().format(reportsList[i].dateTime)}  ${DateFormat.jm().format(reportsList[i].dateTime)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${reportsList[i].address} - (${reportsList[i].lat}, ${reportsList[i].long})",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          reportsList[i].statement,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          reportsList[i].policeName == null
                              ? ""
                              : reportsList[i].policeName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          reportsList[i].status,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: reportsList[i].status == "Unresolved"
                                  ? Colors.red
                                  : reportsList[i].status == "Processing"
                                      ? Colors.orange
                                      : Colors.green),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('Reports')
                                  .doc(reportsList[i].id)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('logs')
                                  .add({
                                "dateTime": Timestamp.now(),
                                "username": "Admin",
                                "userid": "Admin",
                                "userDocReference": "",
                                "logMessage":
                                    "Deleted a report with an id of ${reportsList[i].id}"
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )),
                    ]),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showDetails(data) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBold(
                  text: 'Witness Information',
                  fontSize: 18,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextRegular(
                  text: 'Name: ${data['name']}',
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextRegular(
                  text: 'Contact Number: ${data['contactNumber']}',
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextRegular(
                  text: 'Address: ${data['address']}',
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextBold(
                  text: 'Incident Information',
                  fontSize: 18,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextRegular(
                  text: 'Incident Type: ${data['type']}',
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                TextRegular(
                  text: 'Statement: ${data['statement']}',
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
