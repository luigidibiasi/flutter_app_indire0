import 'package:flutter/material.dart';
import 'package:flutter_app2/screens/screen_gestione/insert_user.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DataRepository repository = DataRepository();

class HomeUser extends StatefulWidget{
  const HomeUser({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  List<Utente> utenti = [];
  List<Utente>filtered_users = [];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    utenti =  settings?.arguments as List<Utente>;
    filtered_users = repository.filterUserActivities(utenti, selectedDate);

    return Scaffold(
      appBar: AppBar(title: Text("Gestisci attività giornaliera")),
        drawer: NavDrawerAdmin(),
      body: Padding(
          padding: const EdgeInsets.all(20),
        child: ListView(
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
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Text("Lista delle attività gestibili", style: Theme.of(context).textTheme.headline6),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filtered_users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 150,
                      child: Column(
                        children: [
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((filtered_users[index].nome ?? "") + " " + (filtered_users[index].cognome ?? ""), style: Theme.of(context).textTheme.headline4),
                                ],
                              )
                          ),
                        ],
                      )
                    );
                  },
                ),
              ),
            ],
        )),
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

}


