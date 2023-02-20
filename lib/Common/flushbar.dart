import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

bool showTopFlushbarFromActivity(
    String title, String message, BuildContext context) {
  Flushbar(
      title: title,
      message: message,
      titleSize: 12,
      messageSize: 14,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.blueAccent,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 2,microseconds: 100),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      )).show(context);
  return true;
}

bool showTopFlushbarFromProfileError(
    String title, String message , BuildContext context ) {
  Flushbar(
      title: title,
      message: message,
      titleSize: 12,
      messageSize: 14,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.redAccent,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 2,microseconds: 100),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      )
  ).show(context);
  return true;
}