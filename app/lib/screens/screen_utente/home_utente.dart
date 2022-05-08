import 'package:flutter/material.dart';
import 'package:flutter_app2/models/attivita.dart';
import 'package:flutter_app2/screens/screen_gestione/insert_user.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import '../../models/storageitem.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/secure_storage.dart';

DataRepository repository = DataRepository();

class HomeUser extends StatefulWidget{
  const HomeUser({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  final StorageService _storageService = StorageService();
  var _items;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Attività giornaliere")),
      drawer: NavDrawerAdmin(),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
              width: double.infinity,
              height: 570,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text("Scegli data"),
                        ),
                        Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 60,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Text("Lista delle attività giornaliere", style: Theme.of(context).textTheme.headline6),
                  ),
                  activityWidget(),
                ],
              ))),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      helpText: "SELEZIONA DATA",
      cancelText: "ANNULLA",
      confirmText: "CONFERMA",
      fieldHintText: "DATE/MONTH/YEAR",
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  Widget activityWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            Attivita attivita = snapshot.data[index];
            return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text("Ora inizio: "+ (attivita.orainizio?.hour.toString().padLeft(2, '0') ?? "")+":"+(attivita.orainizio?.minute.toString().padLeft(2, '0')  ?? "")
                            + "\nOra fine: " +  (attivita.orafine?.hour.toString().padLeft(2, '0')  ?? "")+":"+(attivita.orafine?.minute.toString().padLeft(2, '0')  ?? "")),
                    ),
                  ],
                )
            );
          },
        );
      },
      future: _getActivities(),
    );
  }

  _getActivities() async {
    _items = await _storageService.readAllSecureData();
    String username = "";
    for (StorageItem s in _items){
      if (s.key == 'username'){
        username = s.value;
        break;
      }
    }
    Utente utente = await repository.getByUsername(username) as Utente;
    List activities = [];
    for (Attivita a in utente.listaAttivita!){
      if (a.data == selectedDate){
        activities.add(a);
      }
    }
    return activities;
  }
}


