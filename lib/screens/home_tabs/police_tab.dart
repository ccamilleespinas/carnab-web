import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class PoliceTab extends StatelessWidget {
  const PoliceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child:
            TextRegular(text: 'Police List', fontSize: 18, color: Colors.black),
      ),
    );
  }
}
