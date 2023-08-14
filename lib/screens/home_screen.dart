import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sunspark_web/screens/home_tabs/citizen_tab.dart';
import 'package:sunspark_web/screens/home_tabs/dashboard_tab.dart';
import 'package:sunspark_web/screens/home_tabs/police_tab.dart';
import 'package:sunspark_web/screens/home_tabs/reports_tab.dart';
import 'package:sunspark_web/services/add_officer.dart';
import 'package:sunspark_web/widgets/text_widget.dart';
import 'package:sunspark_web/widgets/textfield_widget.dart';

import '../widgets/toast_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool dashboardSelected = true;

  bool policeSelected = false;

  bool citizenSelected = false;
  bool reportsSelected = false;

  final nameController = TextEditingController();
  final contactnumberController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: policeSelected
          ? FloatingActionButton(
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: TextBold(
                          text: 'Adding new Police Officer',
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFieldWidget(
                                  label: 'Name of the Officer',
                                  controller: nameController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Contact Number',
                                  controller: contactnumberController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Age', controller: ageController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Gender',
                                  controller: genderController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Address',
                                  controller: addressController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Username',
                                  controller: usernameController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  isObscure: true,
                                  isPassword: true,
                                  label: 'Password',
                                  controller: passwordController),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              register(context);
                            },
                            child: TextBold(
                              text: 'Create',
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      );
                    });
              })
          : null,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
              width: 2,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: showMenu
                    ? Card(
                        child: Container(
                          height: double.infinity,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showMenu = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.menu,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextBold(
                                      text: 'ADMIN',
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Card(
                                    elevation: 3,
                                    child: Container(
                                      height: 400,
                                      width: 175,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 10, 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  dashboardSelected =
                                                      !dashboardSelected;
                                                  policeSelected = false;
                                                  citizenSelected = false;
                                                  reportsSelected = false;
                                                });
                                              },
                                              child: dashboardSelected
                                                  ? TextBold(
                                                      text: 'Dashboard',
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    )
                                                  : TextRegular(
                                                      text: 'Dashboard',
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  policeSelected =
                                                      !policeSelected;
                                                  dashboardSelected = false;
                                                  citizenSelected = false;
                                                  reportsSelected = false;
                                                });
                                              },
                                              child: policeSelected
                                                  ? TextBold(
                                                      text: 'Police List',
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    )
                                                  : TextRegular(
                                                      text: 'Police List',
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  citizenSelected =
                                                      !citizenSelected;
                                                  policeSelected = false;
                                                  dashboardSelected = false;
                                                  reportsSelected = false;
                                                });
                                              },
                                              child: citizenSelected
                                                  ? TextBold(
                                                      text: 'Citizen List',
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    )
                                                  : TextRegular(
                                                      text: 'Citizen List',
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  reportsSelected =
                                                      !reportsSelected;
                                                  policeSelected = false;
                                                  dashboardSelected = false;
                                                  citizenSelected = false;
                                                });
                                              },
                                              child: reportsSelected
                                                  ? TextBold(
                                                      text: 'Reports List',
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    )
                                                  : TextRegular(
                                                      text: 'Reports List',
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            Image.asset(
                                              'assets/images/carnab.png',
                                              height: 75,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showMenu = true;
                              });
                            },
                            icon: const Icon(
                              Icons.menu,
                            ),
                          ),
                        ],
                      ),
              ),
              Expanded(
                child: dashboardSelected
                    ? const DashboardTab()
                    : policeSelected
                        ? const PoliceTab()
                        : citizenSelected
                            ? const CitizenTab()
                            : const ReportsTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: '${usernameController.text}@carnab.com',
          password: passwordController.text);

      addOfficer(
          nameController.text,
          usernameController.text,
          contactnumberController.text,
          ageController.text,
          genderController.text,
          addressController.text);

      showToast("Registered Succesfully!");
      Navigator.pop(context);
    } on Exception catch (e) {
      Navigator.pop(context);
      showToast("An error occurred: $e");
    }
  }
}
