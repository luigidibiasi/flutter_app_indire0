import 'package:flutter/cupertino.dart';
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
  //List<Utente> utenti = [];

  @override
  Widget build(BuildContext context) {
    //RouteSettings? settings = ModalRoute.of(context)?.settings;
    //utenti =  settings?.arguments as List<Utente>;
    //_getUtenti();

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
                ],
              ),
              userWidget(),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.pushNamed(context, '/insert_user');},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget userWidget() {
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Cancella utente'),
                            onPressed: () {
                              _deleteUser(utente);
                              setState(() {});},
                          ),
                          //const SizedBox(width: 8),
                          ElevatedButton(
                            child: const Text('Modifica utente'),
                            onPressed: () {Navigator.pushNamed(context, '/modify_user', arguments: utente.username);},
                          ),
                          //const SizedBox(width: 8),
                        ],
                      )
                    ],
                  )
              );
            },
          );
      },
      future: _getUtenti(),
    );
  }

  void _deleteUser(Utente u){
    repository.deleteUtente(u);
    //utenti.remove(u);
  }

  _getUtenti() async {
    //utenti = await repository.getAllUsers() as List<Utente>;
    List users = await repository.getAllUsers();
    return users;
    //print(utenti.length);
  }

}


