import 'package:financial_management/components/detail_data/show_alert.dart';
import 'package:financial_management/function/detail_data_function.dart';
import 'package:flutter/material.dart';
import '../text_form_field.dart';

Future<dynamic> modalBottomEditData(
  BuildContext context,
  {
    required String textInput,
    String? id,
    String keyUpdate = "",
    Widget? customContent,
    Function()? onSuccess
  }
) {
  final TextEditingController controller = TextEditingController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
    ), 
    builder: (context) => Padding(
      padding: const EdgeInsets.all(10.0).add(EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
      child: customContent ?? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textFormField(hintText: textInput, controller: controller),
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
                  onPressed: () => DetailDataFunction()
                    .updateData(id: id as String, data: {keyUpdate: controller.text})
                    .then((value) => Navigator.pop(context))
                    .catchError((error) => showAlert(context, false)),
                  child: const Text("Ok"),
                ),
              ],
            ),
          )
        ],
      )
    )
  );
}