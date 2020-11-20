import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class DevolaButton extends StatelessWidget {

  final String text;
  final VoidCallback onClick;
  final double fontSize;
  final bool isLoading;
  final Color color;

  const DevolaButton({
    Key key,
    @required this.text,
    @required this.onClick,
    this.fontSize = 14,
    this.isLoading = false,
    this.color = Colors.black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Function click = () {};
    if(!this.isLoading) {
      click = onClick;
    }
    return RaisedButton(
      color: color,
      onPressed: click,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      padding: const EdgeInsets.all(0.0),
      child: this.isLoading ? SizedBox(
        height: fontSize + 5, width: fontSize + 5,
        child: LoadingIndicator(color: Colors.white,),
      ) : Text(
        text, style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
    );
  }

}