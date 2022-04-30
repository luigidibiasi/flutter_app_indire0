import 'package:flutter/material.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';

import '../../services/validator.dart';

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


  final _focusUsername = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusSurname = FocusNode();
  final _focusTel = FocusNode();
  final _focusName = FocusNode();

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      _focusEmail.unfocus();
      _focusPassword.unfocus();
      _focusTel.unfocus();
      _focusUsername.unfocus();
      _focusSurname.unfocus();
      _focusName.unfocus();
    },
    child: Scaffold(
      appBar: AppBar(title: Text("Registra nuovo utente")),
      drawer: NavDrawerAdmin(),
      body:Center(
          child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              ),
          margin: EdgeInsets.all(30),
          child: Padding(
            padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: nameController,
                    focusNode: _focusName,
                    validator: (value) => Validator.validateName(
                      name: value!,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                      labelText: 'Nome',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: surnameController,
                    focusNode: _focusSurname,
                    validator: (value) => Validator.validateSurname(
                      name: value!,
                    ),
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
                  child: TextFormField(
                    controller: telController,
                    focusNode: _focusTel,
                    validator: (value) => Validator.validateTelefono(
                      telefono: value!,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                      labelText: 'Telefono',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: usernameController,
                    focusNode: _focusUsername,
                    validator: (value) =>Validator.validateUsername(username: value!),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    focusNode: _focusPassword,
                    validator: (value) => Validator.validatePassword(password: value!),
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
                      if (_formKey.currentState!.validate()) {
                        if (await _validate()) {
                          //List<Utente> utenti = await repository.getAllUsers();
                          //Navigator.pushReplacementNamed(context, '/manage_users', arguments: utenti);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text("Registra utente"),
                  ),
                ),
              ],
            )
          )),
    ),)));
  }

  Future<bool> _validate() async {
    String name = nameController.text;
    String surname = surnameController.text;
    String email = emailController.text.trim();
    String username = usernameController.text;
    String password = passwordController.text;
    String passwordRepeat = passwordRepeatController.text;
    String tel = telController.text;

    var result = await repository.checkEmail(email);
    if (result){
      _showErrorDialog("Email già usata!");
      return false;
    }

    result = await repository.checkTelefono(tel);
    if (result){
      _showErrorDialog("Numero di cellulare non disponibile!");
      return false;
    }

    result = await repository.checkUsername(username);
    if (result){
      _showErrorDialog("Username non disponibile!");
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