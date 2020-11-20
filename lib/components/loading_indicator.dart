import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const LoadingIndicator({
    Key key,
    this.color = const Color.fromRGBO(71, 137, 255, 1),
    this.size = 4
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: size,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }

}