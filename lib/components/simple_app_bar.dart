import 'package:flutter/material.dart';

AppBar simpleAppBar({
  required String title,
  List<Widget>? actions
}) {
  return AppBar(
    title: Text(title),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.green.shade400,
    actions: actions,
  );
}