// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

List<Report> reportFromJson(String str) =>
    List<Report>.from(json.decode(str).map((x) => Report.fromJson(x)));

String reportToJson(List<Report> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Report {
  List<String> evidencePhoto;
  double long;
  String id;
  double lat;
  DateTime dateTime;
  String statement;
  int month;
  String type;
  String nabuaResident;
  String status;
  String address;
  String name;
  String validId;
  String contactNumber;
  int day;
  DateTime dateAndTime;
  int year;
  DateTime? dateTaken;
  String? policeName;

  Report({
    required this.evidencePhoto,
    required this.long,
    required this.id,
    required this.lat,
    required this.dateTime,
    required this.statement,
    required this.month,
    required this.type,
    required this.nabuaResident,
    required this.status,
    required this.address,
    required this.name,
    required this.validId,
    required this.contactNumber,
    required this.day,
    required this.dateAndTime,
    required this.year,
    this.dateTaken,
    this.policeName,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        evidencePhoto: List<String>.from(json["evidencePhoto"].map((x) => x)),
        long: json["long"]?.toDouble(),
        id: json["id"],
        lat: json["lat"]?.toDouble(),
        dateTime: DateTime.parse(json["dateTime"]),
        statement: json["statement"],
        month: json["month"],
        type: json["type"],
        nabuaResident: json["nabuaResident"],
        status: json["status"],
        address: json["address"],
        name: json["name"],
        validId: json["validID"],
        contactNumber: json["contactNumber"],
        day: json["day"],
        dateAndTime: DateTime.parse(json["dateAndTime"]),
        year: json["year"],
        dateTaken: json["date_taken"] == null
            ? null
            : DateTime.parse(json["date_taken"]),
        policeName: json["police_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "evidencePhoto": List<dynamic>.from(evidencePhoto.map((x) => x)),
        "long": long,
        "id": id,
        "lat": lat,
        "dateTime": dateTime.toIso8601String(),
        "statement": statement,
        "month": month,
        "type": type,
        "nabuaResident": nabuaResident,
        "status": status,
        "address": address,
        "name": name,
        "validID": validId,
        "contactNumber": contactNumber,
        "day": day,
        "dateAndTime": dateAndTime.toIso8601String(),
        "year": year,
        "date_taken": dateTaken?.toIso8601String(),
        "police_name": policeName,
      };
}
