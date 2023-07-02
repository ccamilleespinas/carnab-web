import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class CitizenTab extends StatefulWidget {
  const CitizenTab({super.key});

  @override
  State<CitizenTab> createState() => _CitizenTabState();
}

class _CitizenTabState extends State<CitizenTab> {
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
                text: 'Citizen List',
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
                      hintText: 'Search Citizen',
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
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: TextBold(
                          text: 'Name of the citizen',
                          fontSize: 18,
                          color: Colors.black),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextRegular(
                              text: 'Contact Number of the citizen',
                              fontSize: 14,
                              color: Colors.grey),
                          const SizedBox(
                            height: 5,
                          ),
                          TextRegular(
                              text: 'Address of the citizen',
                              fontSize: 14,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
