import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child:
            TextRegular(text: 'Dashboard', fontSize: 18, color: Colors.black),
      ),
    );
  }
}
