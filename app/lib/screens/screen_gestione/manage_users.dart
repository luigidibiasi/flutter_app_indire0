import 'package:flutter/material.dart';
import 'package:flutter_app2/screens/screen_gestione/insert_user.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DataRepository repository = DataRepository();

class ManageUsers extends StatefulWidget{
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  List<Utente> utenti = [];

  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    utenti =  settings?.arguments as List<Utente>;

    return Scaffold(
      appBar: AppBar(title: Text("Gestisci utenti")),
        drawer: NavDrawerAdmin(),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("Lista utenti", style: Theme.of(context).textTheme.headline2),
                  ),
                  Container(
                      height: 60,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/insert_user');
                        },
                        child: Text("Ins"),
                      )
                  ),
                ],
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: utenti.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 150,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text((utenti[index].nome ?? "") + " " + (utenti[index].cognome ?? ""), style: Theme.of(context).textTheme.headline4),
                              Text("Username: "+ (utenti[index].username ?? ""), style: Theme.of(context).textTheme.headline4),
                            ],
                          )
                        ),
                        Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 60,
                                    alignment: Alignment.topRight,
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: (){
                                        _deleteUser(utenti[index]);
                                        setState(() {});
                                      },
                                      child: Text("Cancella utente"),
                                    )
                                ),
                                Container(
                                    height: 60,
                                    alignment: Alignment.topRight,
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, '/insert_user');
                                      },
                                      child: Text("Modifica utente"),
                                    )
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
      )
    );
  }

  void _deleteUser(Utente u){
    //repository.deleteUtente(u);
    utenti.remove(u);
  }

}


