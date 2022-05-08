import 'package:flutter/material.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import '../../models/utente.dart';
import '../../models/attivita.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
              Expanded(
                child:activityWidget(),
              )
            ],
        ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.pushNamed(context, '/insert_activity', arguments: selectedDate).then((_) => setState(() {}));},
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
          physics: ScrollPhysics(), ///
          shrinkWrap: true, ///
          scrollDirection: Axis.vertical,
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
                                children: [Text("Ora inizio: "+ (attivita.orainizio?.hour.toString().padLeft(2, '0') ?? "")+":"+(attivita.orainizio?.minute.toString().padLeft(2, '0') ?? "")
                              + "\nOra fine: " +  (attivita.orafine?.hour.toString().padLeft(2, '0') ?? "")+":"+(attivita.orafine?.minute.toString().padLeft(2, '0') ?? ""),
                              )
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(child: Text('Modifica'), onPressed: () {
                                    Navigator.pushReplacementNamed(context, '/modify_activity', arguments: [utente, attivita]).then((_) => setState(() {}));
                                }),
                                TextButton(child: Text('Elimina'), onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: Text(
                                              "Sei sicuro di voler eliminare l'attività?"),
                                          actions: <Widget>[
                                            new ElevatedButton(
                                              onPressed: () => Navigator.pop(context), // Closes the dialog
                                              child: new Text('No'),
                                            ),
                                            new ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteActivity(attivita, utente);
                                                setState(() {});
                                              },
                                              child: new Text('Sì'),
                                            ),
                                          ],
                                        ),
                                  );
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

    final Email email_cancellazione = Email(
      body: "L'attività prevista in data ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
          " dalle ore ${a.orainizio?.hour}: ${a.orainizio?.minute} alle ${a.orafine?.hour}: ${a.orafine?.minute} è stata assegnata ad un nuovo utente",
      subject: 'cancellazione attività',
      recipients: [u.email!],
      isHTML: false,
    );
    FlutterEmailSender.send(email_cancellazione);
  }
}


