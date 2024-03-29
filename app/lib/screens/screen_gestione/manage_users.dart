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
          /*child: Container(
          //width: double.infinity,
          height: 570,
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),*/
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: Text(
                      'Lista utenti',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                ],
              ),
              userWidget(),
            ],
          ),
        ),
        //),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.pushNamed(context, '/insert_user').then((_) => setState(() {}));},
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
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
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
                          Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: TextButton(child: Text('Modifica'), onPressed: () {
                                Navigator.pushNamed(context, '/modify_user', arguments: utente).then((_) => setState(() {}));},
                              )),
                          Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: TextButton(child: Text('Elimina'), onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: Text(
                                              "Sei sicuro di voler eliminare l'utente?"),
                                          actions: <Widget>[
                                            new ElevatedButton(
                                              onPressed: () => Navigator.pop(context), // Closes the dialog
                                              child: new Text('No'),
                                            ),
                                            new ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteUser(utente);
                                                setState(() {});
                                              },
                                              child: new Text('Sì'),
                                            ),
                                          ],
                                        ),
                                  );
                                  //_deleteUser(utente);
                                  },
                              )),
                          //const SizedBox(width: 8),

                          //const SizedBox(width: 8),
                        ],
                      )
                    ],
                  )
              );
            },
          ),
        );
      },
      future: _getUtenti(),
    );
  }

  void _deleteUser(Utente u){
    repository.deleteUtente(u);
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(
                'Utente eliminato!'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context);
                  },
                  child: Text('Chiudi'))
            ],
          ),
    );
    //utenti.remove(u);
  }

  _getUtenti() async {
    //utenti = await repository.getAllUsers() as List<Utente>;
    List users = await repository.getAllUsers();
    return users;
    //print(utenti.length);
  }

}


