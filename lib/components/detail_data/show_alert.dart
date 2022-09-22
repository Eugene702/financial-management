import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future showAlert(BuildContext context, bool status) {
  return AwesomeDialog(
    context: context,
    dialogType: status ? DialogType.success : DialogType.error,
    title: status ? "Berhasil!" : "Gagal!",
    desc: status ? "Data berhasil diubah!" : "Ada kesalahan pada server!"
  ).show();
}