import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DevolaUtils {

  static showDialog(text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static String putZero(int time) {
    return (time < 10)? '0$time' : time.toString();
  }

  static String removeZero(String str) {
    int i = 0;
    for(; i < str.length; i++) {
      if(str[i] != '0') break;
    }
    return str.substring(i, str.length);
  }

  static String getDateAsLocal(String date, {
    bool hasTime = false,
    bool onlyTime = false,
    bool withoutYear = false,
  }) {
    DateTime dateTime = DateTime.parse(date).toUtc();
    String dateTimeStr;
    if(hasTime) {
      String time = '${putZero(dateTime.hour)}:${putZero(dateTime.minute)}';
      if(onlyTime) {
        return time;
      } else {
        dateTimeStr = '${dateTime.year}-${putZero(dateTime.month)}-${putZero(dateTime.day)}';
        dateTimeStr += ' $time';
        return dateTimeStr;
      }
    } else {
      if(withoutYear) return '${putZero(dateTime.month)}-${putZero(dateTime.day)}';
      return '${dateTime.year}-${putZero(dateTime.month)}-${putZero(dateTime.day)}';
    }
  }

  static bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  static bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

}