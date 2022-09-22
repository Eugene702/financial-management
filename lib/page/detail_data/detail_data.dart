import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_management/components/simple_app_bar.dart';
import 'package:financial_management/function/detail_data_function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/detail_data/bio_card.dart';
import '../../components/detail_data/modal_bottom_edit_data.dart';
import '../../components/detail_data/show_alert.dart';
import '../../components/detail_data/table_mutation.dart';

class DetailData extends StatefulWidget {
  final String id;
  const DetailData({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailData> createState() => _DetailDataState();
}

class _DetailDataState extends State<DetailData> {
  String titleAppbar = "";
  TextEditingController inputMountMutation = TextEditingController();
  TextEditingController inputMValueMutation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> data = FirebaseFirestore.instance.collection("data").doc(widget.id).snapshots();
    Stream<QuerySnapshot> mutation = FirebaseFirestore.instance.collection("mutation").where("id", isEqualTo: widget.id).snapshots();
    NumberFormat currencyFormat = NumberFormat.simpleCurrency(
      locale: 'id',
      name: 'Rp. ',
      decimalDigits: 2
    );

    return Scaffold(
      appBar: simpleAppBar(title: titleAppbar),
      body: StreamBuilder(
        stream: data,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Center(child: Text("Ada kesalahan pada server!"),);
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: Text("Sedang mengambil data"),);
          }

          if(snapshot.hasData){
            DocumentSnapshot data = snapshot.data as DocumentSnapshot;
            if(data.exists){
              titleAppbar = data["name"];

              return ListView(
                children: [
                  bioCard(
                    title: "Nama Pengguna",
                    subtitle: data["name"],
                    leading: Icons.person_rounded,
                    onPressed: () => modalBottomEditData(context, id: widget.id, textInput: "Masukan nama baru", keyUpdate: "name"),
                  ),
                  bioCard(
                    title: "PIN",
                    subtitle: data["pin"],
                    leading: Icons.pin_rounded,
                    onPressed: () => modalBottomEditData(context, textInput: "Masukan PIN baru", id: widget.id, keyUpdate: "pin")
                  ),
                  bioCard(
                    title: "Warna Kartu",
                    subtitle: data["color"],
                    leading: Icons.color_lens_rounded,
                    onPressed: () => modalBottomEditData(context, textInput: "Masukan warna kartu baru", id: widget.id, keyUpdate: "color")
                  ),
                  bioCard(
                    title: "Status Pengguna",
                    subtitle: data["user_active"] ? "Aktif" : "Tidak Aktif",
                    leading: Icons.lock_person_rounded,
                    editing: false,
                    trailing: IconButton(
                      onPressed: () => DetailDataFunction()
                        .updateData(id: widget.id, data: {"user_active": !data["user_active"]})
                        .catchError((error) => AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "Gagal!",
                          desc: "Kesalahan pada server!"
                        ).show()),
                      splashRadius: 20.0,
                      icon: const Icon(Icons.change_circle_rounded),
                    )
                  ),
            
                  const SizedBox(height: 20.0,),
                  tableMutation(mutation, currencyFormat, inputMountMutation, inputMValueMutation, widget.id),
                  const SizedBox(height: 20.0,),
                  IconButton(
                    onPressed: () => AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        title: "Apakah anda yakin ingin menghapus?",
                        btnOkOnPress: () => DetailDataFunction().removeUser(widget.id),
                        btnCancelOnPress: (){}
                      ).show(), 
                    tooltip: "Hapus pengguna",
                    color: Colors.red.shade400,
                    iconSize: 50.0,
                    icon: const Icon(Icons.delete_rounded)
                  )
                ],
              );
            }else{
              return const Center(child: Text("Tidak ada data!"),);
            }
          }

          return const Center(child: Text("Tidak ada data!"),);
        },
      )
    );
  }
}