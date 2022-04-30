import 'package:flutter/material.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import '../../models/utente.dart';
import '../../models/attivita.dart';
import '../../repository/data_repository.dart';

DataRepository repository = DataRepository();

class ManageActivities extends StatefulWidget{
  const ManageActivities({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManageActivitiesState();
}

class _ManageActivitiesState extends State<ManageActivities> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

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
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Text("Lista delle attività giornaliere", style: Theme.of(context).textTheme.headline6),
              ),
              activityWidget(),
            ],
        )),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.pushNamed(context, '/insert_activity').then((_) => setState(() {}));},
        child: Icon(Icons.add),
      ),
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
            Attivita attivita = snapshot.data.keys.elementAt(index);
            Utente utente = snapshot.data.values.elementAt(index);
            return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text((utente.nome ?? "") + " " + (utente.cognome ?? "")),
                      subtitle: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                                children: [Text("Ora inizio: "+ (attivita.orainizio?.hour.toString() ?? "")+":"+(attivita.orainizio?.minute.toString() ?? "")
                              + "\nOra fine: " +  (attivita.orafine?.hour.toString() ?? "")+":"+(attivita.orafine?.minute.toString() ?? ""),
                              )
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(child: Text('Modifica'), onPressed: () {
                                    Navigator.pushNamed(context, '/modify_activity', arguments: [utente, attivita]).then((_) => setState(() {}));
                                }),
                                TextButton(child: Text('Elimina'), onPressed: () {
                                  _deleteActivity(attivita, utente);
                                  setState(() {
                                  });
                                })
                              ],
                            )
                          ]
                      )
                    ),
                  ],
                )
            );
          },
        );
      },
      future: _getFilteredUsers(),
    );
  }

  _getFilteredUsers() async {
    List<Utente> users = await repository.getAllUsers() as List<Utente>;
    Map activities = repository.getUserAndActivities(users, selectedDate);
    return activities;
  }

  _deleteActivity(Attivita a, Utente u){
    u.deleteActivity(a);
    repository.updateUtente(u);
  }
}


