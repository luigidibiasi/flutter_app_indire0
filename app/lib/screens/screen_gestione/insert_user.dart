import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DataRepository repository = DataRepository();

class InsertUser extends StatefulWidget{
  const InsertUser({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InsertUserState();
}

class _InsertUserState extends State<InsertUser> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  TextEditingController telController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registra nuovo utente")),
      body: Padding(
          padding: const EdgeInsets.all(50),
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Nome',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: surnameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Cognome',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: telController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Telefono',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Username',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: TextField(
                  obscureText: true,
                  controller: passwordRepeatController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Conferma password',
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    print(usernameController.text);
                    print(passwordController.text);
                    if (await _validate()){
                      List<Utente> utenti = await repository.getAllUsers();
                      Navigator.pushReplacementNamed(context, '/manage_users', arguments: utenti);
                    }
                  },
                  child: Text("Registra utente"),
                ),
              ),
            ],
          )),
    );
  }

  Future<bool> _validate() async {
    String name = nameController.text;
    String surname = surnameController.text;
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String passwordRepeat = passwordRepeatController.text;
    String tel = telController.text;

    if (name.length==0) {
      _showErrorDialog("Campo nome obbligatorio!");
      return false;
    }

    if (surname.length==0) {
      _showErrorDialog("Campo cognome obbligatorio!");
      return false;
    }

    //controllo se username disponibile
    var result = repository.checkUsername(username);
    if (await result) {
      _showErrorDialog("Username non disponibile");
      return false;
    }

    //controllo formato email
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (!emailValid){
      _showErrorDialog("Formato email non valido");
      return false;
    }

    //controllo unicità email
    result = repository.checkEmail(email);
    if (await result) {
      _showErrorDialog("Email non disponibile");
      return false;
    }

    //controllo formato cellulare
    bool telValid = RegExp(r"^[0-9]{10}").hasMatch(tel);
    if (!telValid){
      _showErrorDialog("Formato cellulare non valido");
      return false;
    }

    //controllo unicità cellulare
    result = repository.checkTelefono(tel);
    if (await result) {
      _showErrorDialog("Numero cellulare già utilizzato");
      return false;
    }

    //controllo password
    if (password != passwordRepeat) {
      _showErrorDialog("Password non corrispondenti!");
      return false;
    }

    final newUser = Utente(username, nome: name, cognome: surname, email: email, password: password, telefono: tel, admin: false, listaAttivita: []);
    repository.addUtente(newUser);
    return true;
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