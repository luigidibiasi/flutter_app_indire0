import 'package:flutter/material.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import 'package:flutter_app2/models/utente.dart';
import 'package:flutter_app2/repository/data_repository.dart';

DataRepository repository = DataRepository();

class MenuAdmin extends StatelessWidget{
  const MenuAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: NavDrawerAdmin(),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: Image.asset('assets/img/logo.jpeg',
                  fit: BoxFit.contain,
                  width: 200,),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: ElevatedButton(
                  onPressed: () async {
                    //List<Utente> utenti = await repository.getAllUsers();
                    //print(utenti.length);
                    //Navigator.pushNamed(context, '/manage_users', arguments: utenti);
                    Navigator.pushNamed(context, '/manage_users');
                  },
                  child: Text("Gestisci utenti"),
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: ElevatedButton (
                  onPressed: () async{
                    List<Utente> utenti = await repository.getAllUsers();
                    Navigator.pushNamed(context, '/manage_activities', arguments: utenti);
                  },
                  child: Text("Gestisci attività giornaliera"),
                ),
              ),
            ]
        )
      ),
    );
  }
}



