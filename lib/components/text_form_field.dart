import 'package:flutter/material.dart';

Theme textFormField({
  required String hintText,
  TextEditingController? controller,
  Widget? icon,
  bool isDense = false,
  TextInputType? keyboardType,
  double contentPadding = 7.0,
  Function(String)? onChanged
}) {
  return Theme(
    data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.green.shade400)),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        icon: icon,
        isDense: isDense,
        contentPadding: EdgeInsets.all(contentPadding),
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none
        )
      ),
    ),
  );
}