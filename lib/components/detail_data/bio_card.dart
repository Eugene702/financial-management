import 'package:flutter/material.dart';

Card bioCard({
  required String title,
  String? subtitle,
  IconData? leading,
  Function()? onPressed,
  bool editing = true,
  Widget? trailing
}) {
  return Card(
    shape: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1.0)),
    elevation: 0.0,
    color: Colors.transparent,
    child: ListTile(
      dense: true,
      leading: leading != null ? Icon(leading) : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: editing ? IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.edit_rounded),
        tooltip: "Edit Data",
      ) : trailing,
    ),
  );
}