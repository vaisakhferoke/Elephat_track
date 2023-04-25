import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void errorToast(String message,
    {Color? color, ToastGravity? gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color ?? Colors.white,
      textColor: Colors.red,
      fontSize: 16.0);
}
