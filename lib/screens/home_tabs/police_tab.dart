import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sunspark_web/widgets/button_widget.dart';
import 'package:sunspark_web/widgets/textfield_widget.dart';

import '../../widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class PoliceTab extends StatefulWidget {
  const PoliceTab({super.key});

  @override
  State<PoliceTab> createState() => _PoliceTabState();
}

class _PoliceTabState extends State<PoliceTab> {
  String nameSearched = '';

  final searchController = TextEditingController();

  createLogs({required String log}) async {
    await FirebaseFirestore.instance.collection('logs').add({
      "dateTime": Timestamp.now(),
      "username": "Admin",
      "userid": "Admin",
      "userDocReference": "",
      "logMessage": log
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 50, 20),
      child: SizedBox(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextBold(
                text: 'Police Officer List',
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
                    setState(() {
                      nameSearched = value;
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search Officer',
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
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Officers')
                  .where('name',
                      isGreaterThanOrEqualTo:
                          toBeginningOfSentenceCase(nameSearched))
                  .where('name',
                      isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('waiting');
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    )),
                  );
                }

                final data = snapshot.requireData;

                return Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              onTap: () {
                                showDetails(
                                    data: data.docs[index].data() as Map,
                                    id: data.docs[index].id);
                              },
                              title: TextBold(
                                  text: data.docs[index]['name'],
                                  fontSize: 18,
                                  color: Colors.black),
                              subtitle: TextRegular(
                                  text: data.docs[index]['contactnumber'],
                                  fontSize: 14,
                                  color: Colors.grey),
                              trailing: data.docs[index]['status'] == 'Active'
                                  ? InkWell(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Officers')
                                            .doc(data.docs[index]['id'])
                                            .update({"status": "inActive"});
                                        createLogs(
                                            log:
                                                "Police officer ${data.docs[index]['name']}'s account update status to inactive");
                                      },
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.green,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Officers')
                                            .doc(data.docs[index]['id'])
                                            .update({"status": "Active"});
                                        createLogs(
                                            log:
                                                "Police officer ${data.docs[index]['name']}'s account update status to active");
                                      },
                                      child: const Icon(
                                        Icons.person_off,
                                        color: Colors.red,
                                      ),
                                    )),
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      )),
    );
  }

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();
  final birthDateController = TextEditingController();
  DateTime birthdate = DateTime.now();

  showDetails({required Map data, required String id}) {
    birthDateController.clear();
    setState(() {
      nameController.text = data['name'] ?? "";
      ageController.text = data['age'] ?? "";
      addressController.text = data['address'] ?? "";
      genderController.text = data['gender'] ?? "";
      contactNumberController.text = data['contactnumber'] ?? "";
      if (data.containsKey("birthdate")) {
        birthDateController.text = DateFormat.yMMMMd()
            .format(DateTime.parse(data['birthdate'].toDate().toString()));
        birthdate = data['birthdate'].toDate();
      }
    });
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/profile.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      label: 'Name',
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextRegular(
                        text: 'Full Name', fontSize: 12, color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: birthDateController,
                              enabled: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.01),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () async {
                              var datepick = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900, 1, 1),
                                  lastDate: DateTime.now());

                              if (datepick != null) {
                                Duration difference =
                                    DateTime.now().difference(datepick);
                                int age = (difference.inDays / 365).floor();
                                ageController.text = age.toString();
                                birthDateController.text =
                                    DateFormat.yMMMMd().format(datepick);
                                birthdate = datepick;
                              }
                            },
                            child: const Icon(Icons.calendar_month))
                      ],
                    ),
                    TextRegular(
                        text: "Birth Date", fontSize: 12, color: Colors.grey),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFieldWidget(
                      label: '',
                      controller: ageController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextRegular(text: 'Age', fontSize: 12, color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      label: 'Gender',
                      controller: genderController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextRegular(
                        text: 'Gender', fontSize: 12, color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      label: 'Contact no.',
                      controller: contactNumberController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextRegular(
                        text: 'Contact no.', fontSize: 12, color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      label: 'Address',
                      controller: addressController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextRegular(
                        text: 'Address', fontSize: 12, color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      label: 'Save',
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('Officers')
                            .doc(id)
                            .update({
                          'birthdate': birthdate,
                          'name': nameController.text,
                          'age': ageController.text,
                          'gender': genderController.text,
                          'address': addressController.text,
                          'contactnumber': contactNumberController.text
                        });
                        await FirebaseFirestore.instance
                            .collection('logs')
                            .add({
                          "dateTime": Timestamp.now(),
                          "username": "Admin",
                          "userid": "Admin",
                          "userDocReference": "",
                          "logMessage":
                              "Updated ${nameController.text}'s account details"
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
