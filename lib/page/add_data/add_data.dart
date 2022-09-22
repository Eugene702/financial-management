import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:financial_management/components/simple_app_bar.dart';
import 'package:financial_management/components/text_form_field.dart';
import 'package:financial_management/function/add_data_function.dart';
import 'package:flutter/material.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  bool userActive = true;
  TextEditingController name = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController color = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: "Tambah Data"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  textFormField(controller: name, icon: const Icon(Icons.person_rounded), hintText: "Masukan nama pemilik"),
                  const SizedBox(height: 20.0,),
                  textFormField(controller: pin, icon: const Icon(Icons.pin_rounded), hintText: "Masukan PIN", keyboardType: TextInputType.number),
                  const SizedBox(height: 20.0,),
                  textFormField(controller: color, icon: const Icon(Icons.color_lens_rounded), hintText: "Masukan Warna kartu"),
                  const SizedBox(height: 20.0,),
                  DropdownButton(
                    onChanged: (val) => setState(() => userActive = val as bool),
                    hint: const Text("Status pengguna"),
                    value: userActive,
                    items: const [
                      DropdownMenuItem(
                        value: true,
                        child: Text("On"),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text("Off"),
                      ),
                    ],
                  ),

                  MaterialButton(
                    onPressed: ()
                    {
                      AddDataFunction().saveData(name: name.text, color: color.text, pin: pin.text, status: userActive)
                        .then((value) => AwesomeDialog(
                            context: context,
                            title: "Berhasil!",
                            desc: "Data berhasil ditambahkan!",
                            dialogType: DialogType.success
                          ).show()
                        ).catchError((error) => AwesomeDialog(
                            context: context,
                            title: "Kesalahan!",
                            desc: "Ada kesalahan pada server. Coba lagi nanti!",
                            dialogType: DialogType.error
                          ).show()
                        );
                      
                      name.clear();
                      pin.clear();
                      color.clear();
                    },
                    color: Colors.green.shade400,
                    elevation: 0.0,
                    highlightElevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.save_rounded, color: Colors.white,),
                        SizedBox(width: 5.0,),
                        Text("Simpan Data", style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}