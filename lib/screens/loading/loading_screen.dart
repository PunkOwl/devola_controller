import 'package:devola_controller/components/loading_indicator.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingIndicator()
          ],
        )
      ],
    );
  }

}