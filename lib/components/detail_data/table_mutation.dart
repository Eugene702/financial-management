import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_management/components/detail_data/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/text_form_field.dart';
import '../../function/detail_data_function.dart';
import 'modal_bottom_edit_data.dart';

StreamBuilder<QuerySnapshot<Object?>> tableMutation(
  Stream<QuerySnapshot<Object?>> mutation, 
  NumberFormat currencyFormat,
  TextEditingController inputMountMutation,
  TextEditingController inputValueMutation,
  String id
) {
  return StreamBuilder<QuerySnapshot>(
    stream: mutation,
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(child: Text("Sedang mengambil data mutasi"),);
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("Mutasi Transaksi"),
              trailing: Theme(
                data: ThemeData.from(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.green.shade400)),
                child: TextButton(
                  child: const Text("Tambah Mutasi"),
                  onPressed: () => modalBottomEditData(
                    context, 
                    textInput: "Masukan nominal baru",
                    customContent: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textFormField(hintText: "Masukan bulan mutasi", controller: inputMountMutation),
                      const SizedBox(height: 10.0,),
                      textFormField(hintText: "Masukan nominal mutasi", controller: inputValueMutation, keyboardType: TextInputType.number),
                      Theme(
                        data: ThemeData.from(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.green.shade400)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => DetailDataFunction().addDataMutation(
                                id: id, 
                                mount: inputMountMutation.text, 
                                value: int.parse(inputValueMutation.text)
                              ).then((value){
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  title: "Berhasil!",
                                  desc: "Mutasi berhasil ditambahkan!"
                                ).show();
                                inputMountMutation.clear();
                                inputValueMutation.clear();
                              }).catchError((error){
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  title: "Gagal!",
                                  desc: "Kesalahan pada server!"
                                ).show();
                              }),
                              child: const Text("Ok"),
                            ),
                          ],
                        ),
                      )
                    ],)
                  ),
                ),
              ),
            ),
          
            DataTable(
              columns: const [
                DataColumn(label: Text("Bulan")),
                DataColumn(label: Text("Nominal"), numeric: true),
              ],
          
              rows: snapshot.data!.docs.map((e){
                Map<String, dynamic> dataMutation = e.data() as Map<String, dynamic>;
                return DataRow(
                  onLongPress: () => AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    title: "Apakah anda yakin ingin menghapus?",
                    btnOkOnPress: () => DetailDataFunction().removeMutation(e.id)
                      .then((value) => showAlert(context, true))
                      .catchError((error) => showAlert(context, false)),
                    btnCancelOnPress: (){}
                  ).show(),
                  cells: [
                    DataCell(Text(dataMutation["mount"])),
                    DataCell(
                      Text(currencyFormat.format(dataMutation["value"])),
                      onTap: () => modalBottomEditData(
                        context, 
                        textInput: "Masukan nominal baru",
                        customContent: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            textFormField(hintText: "Masukan nominal baru", keyboardType: TextInputType.number, controller: inputValueMutation),
                            Theme(
                              data: ThemeData.from(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.green.shade400)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () => DetailDataFunction().updateMutation(e.id, {"value": int.parse(inputValueMutation.text)})
                                      .then((value) => showAlert(context, true))
                                      .catchError((error) => showAlert(context, false)),
                                    child: const Text("Ok"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      )
                    ),
                  ]
                );
              }).toList()
            ),
          ],
        ),
      );
    }
  );
}