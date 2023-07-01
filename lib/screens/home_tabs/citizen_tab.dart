import 'package:flutter/material.dart';
import 'package:sunspark_web/widgets/text_widget.dart';

class CitizenTab extends StatelessWidget {
  const CitizenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextRegular(
            text: 'Citizen List', fontSize: 18, color: Colors.black),
      ),
    );
  }
}
