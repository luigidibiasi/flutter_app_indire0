import 'package:flutter/material.dart';
import '../../models/attivita.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';

DataRepository repository = DataRepository();

class ModifyActivity extends StatefulWidget{
  const ModifyActivity({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifyActivityState();
}

class _ModifyActivityState extends State<ModifyActivity> {
  String? dropDownValue;
  DateTime selectedDate = DateTime.now();
  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    List arguments = settings?.arguments as List;
    Utente utente = arguments[0];
    Attivita attivita = arguments[1];
    selectedDate = attivita.data!;
    start = attivita.orainizio!;
    end = attivita.orafine!;
    //utenti =  settings?.arguments as List<Utente>;
    return Scaffold(
      appBar: AppBar(title: Text("Inserisci attività")),
      drawer: NavDrawerAdmin(),
      body: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(padding: const EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child:
                    Text("Utente: ${utente.nome} ${utente.cognome}")
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child:
                      Text("Data: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                  ),
                Container(
                  alignment: Alignment.topLeft,
                  height: 60,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: Row(
                      children: <Widget>[
                        Text("Orario: ${start.hour}:${start.minute}"),
                        Text(" - ${end.hour}:${end.minute}"),
                      ]
                  ),
                ),
                Center(
                  child: availableUserWidget(utente),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await _validate(attivita, utente)){
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Conferma"),
                  ),
                ),
              ],
            ))
      ),
    );
  }

  Widget availableUserWidget(Utente utente){
    return FutureBuilder(
      future: _searchUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
            child: ListTile(
              title: Text("Sostituisci ${utente.nome} ${utente.cognome} con"),
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
              hint: Text(dropDownValue ?? 'Seleziona utente'),
              items: snapshot.data.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item.username,
                  child: Text(item.nome + " " + item.cognome),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropDownValue = value!;
                  print(value);
                });
              },
            )
        )
            )
        );
      },
    );
  }

  Future<bool> _validate(Attivita a, Utente utente) async {
    //check data
    if (dropDownValue == null){
      _showErrorDialog("Seleziona l'utente a cui vuoi assegnare l'attività!");
      return false;
    }

    Utente? utente_new = await repository.getByEmail(dropDownValue!) as Utente?;
    print(utente_new);

    utente_new?.listaAttivita?.add(a);
    utente.listaAttivita?.remove(a);
    repository.updateUtente(utente);

    repository.updateUtente(utente_new!);
    return true;
  }

  _searchUsers() async{
    List<Utente> utenti = await repository.getAllUsers() as List<Utente>;
    List<Utente> availableusers = repository.getAvailableUsers(utenti, selectedDate, start, end);
    print(availableusers.length);
    return availableusers;
  }


  void _showErrorDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: new Text('Warning'),
          content: new Text(text),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ));
  }



}