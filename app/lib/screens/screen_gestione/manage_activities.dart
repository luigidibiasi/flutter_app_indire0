import 'package:flutter/material.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';

DataRepository repository = DataRepository();

class ManageActivities extends StatefulWidget{
  const ManageActivities({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManageActivitiesState();
}

class _ManageActivitiesState extends State<ManageActivities> {
  //List<Utente> utenti = [];
  //List<Utente>filtered_users = [];
  DateTime selectedDate = DateTime.now();



  @override
  Widget build(BuildContext context) {
    /*RouteSettings? settings = ModalRoute.of(context)?.settings;
    utenti =  settings?.arguments as List<Utente>;
    filtered_users = repository.filterUserActivities(utenti, selectedDate);*/

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
              Row(
                children:[
                  Container(
                    alignment: Alignment.topLeft,
                    height: 60,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Text("Lista delle attività gestibili", style: Theme.of(context).textTheme.headline6),
                  ),
                  Container(
                    height: 60,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.lightBlueAccent,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/insert_activity');
                          },
                          icon: const Icon(Icons.add),
                          iconSize: 40,
                          color: Colors.white,
                        )
                    ),
                  ),
                ],
              ),
              activityWidget(),
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
            Utente utente = snapshot.data[index];
            return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.supervised_user_circle),
                      title: Text((utente.nome ?? "") + " " + (utente.cognome ?? "")),
                      subtitle: Text("Username: "+ (utente.username ?? "")),
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
    List filtered_users = repository.filterUserActivities(users, selectedDate);
    return filtered_users;
  }

}


