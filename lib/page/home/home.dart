import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_management/page/add_data/add_data.dart';
import 'package:financial_management/page/detail_data/detail_data.dart';
import 'package:flutter/material.dart';
import '../../components/simple_app_bar.dart';
import '../../components/text_form_field.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController querySearch = TextEditingController();
  String queryText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "Manajemen Keuangan",
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddData())),
            icon: const Icon(Icons.add_rounded),
            splashRadius: 20.0,
            tooltip: "Tambah Data",
          )
        ]
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            textFormField(hintText: "Cari disini", onChanged: (val){setState(() => queryText = val);}),
            const SizedBox(height: 20.0,),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("data").where("name", isGreaterThanOrEqualTo: queryText, isLessThan: '${queryText}z').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: Text("Sedang mengambil data")
                  );
                }

                if(snapshot.data!.size == 0){
                  return const Center(
                    child: Text("Belum ada data"),
                  );
                }else{
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((document){
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade400, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(data['name']),
                              subtitle: Text("Status : ${data['user_active']}"),
                              trailing: IconButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailData(id: document.id,))),
                                splashRadius: 20.0,
                                tooltip: "Lebih Detail",
                                icon: const Icon(Icons.remove_red_eye_rounded),
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    ),
                  );
                }
              }
            ),
          ],
        ),
      )
    );
  }
}