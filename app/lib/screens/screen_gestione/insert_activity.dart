import 'package:flutter/material.dart';
import 'package:flutter_app2/models/attivita.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

DataRepository repository = DataRepository();

class InsertActivity extends StatefulWidget{
  const InsertActivity({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InsertActivityState();
}

class _InsertActivityState extends State<InsertActivity> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();
  String? dropDownValue;
  bool first = true;

  @override
  void initState() {
    super.initState();
    //end = _initializeEnd();
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    selectedDate = settings?.arguments as DateTime;
    end = _initializeEnd();
    return Scaffold(
      appBar: AppBar(title: Text("Inserisci attività")),
      drawer: NavDrawerAdmin(),
      body: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(30),
          child: Container(
            height: 400,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              _selectDate(context);
                              setState(() {
                              });
                            },
                            child: Text("Scegli data"),
                          ),
                          Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",  style: Theme.of(context).textTheme.headlineSmall)
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context);
                                end = _initializeEnd();
                                setState(() {
                                });
                              },
                              child: Text("Scegli orario di inizio"),
                            ),
                            Text("\t${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}",  style: Theme.of(context).textTheme.headlineSmall),
                          ]
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context);
                              },
                              child: Text("Scegli orario di fine"),
                            ),
                            Text("\t${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}",  style: Theme.of(context).textTheme.headlineSmall),
                          ]
                      ),
                    ),
                    Center(
                      child: availableUserWidget(),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (await _validate()){
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: Text(
                                        'Attività assegnata correttamente!'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context);
                                            Navigator.pop(
                                                context);
                                          },
                                          child: Text('Chiudi'))
                                    ],
                                  ),
                            );
                            //Navigator.pop(context);
                          }
                        },
                        child: Text("Assegna attività"),
                      ),
                    ),
                    //activityWidget(),
                  ],
                )),
          )
        )
      )
    );
  }

  Widget availableUserWidget(){
    return FutureBuilder(
      future: _searchUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          child: DropdownButton<String>(
            hint: Text(dropDownValue ?? "Seleziona l'utente"),
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
          ));
      },
    );
  }

  Future<bool> _validate() async {
    //check data
    if (dropDownValue == null){
      _showErrorDialog("Seleziona l'utente a cui vuoi assegnare l'attività!");
      return false;
    }

    Utente? utente = await repository.getByUsername(dropDownValue!) as Utente?;
    print(utente);

    Attivita a = Attivita(selectedDate, start, end);
    utente?.listaAttivita?.add(a);
    repository.updateUtente(utente!);

    final Email send_email = Email(
      body: 'Sei stato assegnato per una nuova attività in data ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
          ' dalle ore ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} alle ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
      subject: 'assegnazione nuova attività',
      recipients: [utente.email!],
      isHTML: false,
    );
    FlutterEmailSender.send(send_email);

    return true;
  }

  _searchUsers() async{
    List<Utente> utenti = await repository.getAllUsers() as List<Utente>;
    List<Utente> availableusers = repository.getAvailableUsers(utenti, selectedDate, start, end);
    print(availableusers.length);
    if (availableusers.length==0 && !first){
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                    "Nessun utente disponibile nella fascia oraria selezionata!"),
                actions: <Widget>[
                  new ElevatedButton(
                    onPressed: () => Navigator.pop(context), // Closes the dialog
                    child: new Text('Chiudi'),
                  ),
                ],
              )
      );
    }
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


  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      helpText: "SELEZIONA DATA",
      cancelText: "ANNULLA",
      confirmText: "CONFERMA",
      fieldHintText: "DATE/MONTH/YEAR",
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        first = false;
      });
    first = false;
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: start,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != start)
    {
      setState(() {
        start = timeOfDay;
        first= false;
      });
    }

  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: end,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != end)
    {
      setState(() {
        end = timeOfDay;
        first = false;
      });
    }
  }

  TimeOfDay _initializeEnd(){
    return start.replacing(
        hour: start.hour + 1,
        minute: start.minute,
    );
  }

}