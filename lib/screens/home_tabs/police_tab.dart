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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 50, 20),
      child: Container(
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
                              showDetails(data.docs[index]);
                            },
                            title: TextBold(
                                text: data.docs[index]['name'],
                                fontSize: 18,
                                color: Colors.black),
                            subtitle: TextRegular(
                                text: data.docs[index]['contactnumber'],
                                fontSize: 14,
                                color: Colors.grey),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                            'Delete Officer Confirmation',
                                            style: TextStyle(
                                                fontFamily: 'QBold',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                            'Are you sure you want to delete this account?',
                                            style: TextStyle(
                                                fontFamily: 'QRegular'),
                                          ),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('Officers')
                                                    .doc(data.docs[index].id)
                                                    .delete();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Continue',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ));
                              },
                              icon: const Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ),
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

  showDetails(data) {
    setState(() {
      nameController.text = data['name'];
      ageController.text = data['age'];
      addressController.text = data['address'];
      genderController.text = data['gender'];
    });
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                  TextFieldWidget(
                    label: 'Age',
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
                  TextRegular(text: 'Gender', fontSize: 12, color: Colors.grey),
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
                          .doc(data.id)
                          .update({
                        'name': nameController.text,
                        'age': ageController.text,
                        'gender': genderController.text,
                        'address': addressController.text,
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
