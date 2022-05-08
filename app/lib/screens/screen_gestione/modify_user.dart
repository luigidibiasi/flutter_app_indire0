import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import 'package:flutter_app2/services/validator.dart';


DataRepository repository = DataRepository();

class ModifyUser extends StatefulWidget {
  @override
  _ModifyUserState createState() => _ModifyUserState();
}

class _ModifyUserState extends State<ModifyUser> {
  Utente? utente;
  final _formKey = GlobalKey<FormState>();

  var _emailTextController = null;
  var _passwordTextController = null;
  var _telefonoTextController = null;

  final _focusTelefono = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();


  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    utente =  settings?.arguments as Utente?;
    _emailTextController = TextEditingController(text: utente?.email);
    _passwordTextController = TextEditingController(text: utente?.password);
    _telefonoTextController = TextEditingController(text: utente?.telefono);

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusTelefono.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Modifica utente'),
        ),
        drawer: NavDrawerAdmin(),
        body: Center(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text((utente?.nome ?? "")+ " "+ (utente?.cognome ?? "") + "\n", style: Theme.of(context).textTheme.headline6),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Username: "+ (utente?.username ?? ""), style: Theme.of(context).textTheme.headline6),
                          ),
                        ],
                        )
                    ),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.all(30),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Expanded(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(
                                  email: value!,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _telefonoTextController,
                                focusNode: _focusTelefono,
                                validator: (value) => Validator.validateTelefono(
                                  telefono: value!,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Telefono",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: true,
                                validator: (value) => Validator.validatePassword(
                                  password: value!,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32.0),
                              Row(
                                children: [
                                  Expanded(child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          String email = _emailTextController
                                              .text.trim();
                                          String password = _passwordTextController
                                              .text;
                                          String telefono = _telefonoTextController
                                              .text.trim();
                                          utente?.email = email;
                                          utente?.password = password;
                                          utente?.telefono = telefono;
                                          repository.updateUtente(utente!);
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialog(
                                                  title: Text(
                                                      'Dati modificati correttamente!'),
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
                                        }
                                      },
                                      child: Text(
                                        'Conferma',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),)
                                ],
                              )
                            ],
                          )),
                      ],
                    ),
                  ),
                ),
      ),
              ],
            )

        ),
      ),
    );
  }

}