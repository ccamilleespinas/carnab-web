import 'package:flutter/material.dart';
import 'package:sunspark_web/screens/home_tabs/citizen_tab.dart';
import 'package:sunspark_web/screens/home_tabs/dashboard_tab.dart';
import 'package:sunspark_web/screens/home_tabs/police_tab.dart';
import 'package:sunspark_web/screens/home_tabs/reports_tab.dart';
import 'package:sunspark_web/widgets/text_widget.dart';
import 'package:sunspark_web/widgets/textfield_widget.dart';

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
                        content: Column(
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
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
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
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
            child: Container(
              height: double.infinity,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBold(
                      text: 'ADMIN',
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        height: 400,
                        width: 175,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    dashboardSelected = !dashboardSelected;
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
                                    policeSelected = !policeSelected;
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
                                    citizenSelected = !citizenSelected;
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
                                    reportsSelected = !reportsSelected;
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: dashboardSelected
                ? DashboardTab()
                : policeSelected
                    ? const PoliceTab()
                    : citizenSelected
                        ? const CitizenTab()
                        : const ReportsTab(),
          ),
        ],
      ),
    );
  }
}
