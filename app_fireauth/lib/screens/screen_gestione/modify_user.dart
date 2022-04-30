import 'package:flutter/material.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app2/services/validator.dart';
import 'package:flutter_app2/services/fire_auth.dart';

DataRepository repository = DataRepository();

class ModifyUser extends StatefulWidget {
  @override
  _ModifyUserState createState() => _ModifyUserState();
}

class _ModifyUserState extends State<ModifyUser> {
  Utente? utente;
  final _registerFormKey = GlobalKey<FormState>();

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
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value!,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
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
                          hintText: "Telefono",
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
                          hintText: "Password",
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
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                String email = _emailTextController.text.trim();
                                String password = _passwordTextController.text();
                                String telefono = _telefonoTextController.text.trim();
                                if (email != utente?.email){
                                  FireAuth.resetEmail(email);
                                  print("email modificata");
                                }
                                if (password != utente?.password){
                                  FireAuth.resetPassword(password);
                                  print("password modificata");
                                }
                                utente?.email = email;
                                utente?.password = password;
                                utente?.telefono = telefono;
                                repository.updateUtente(utente!);
                                /*if (_registerFormKey.currentState!
                                    .validate()) {
                                  User? user = await FireAuth
                                      .registerUsingEmailPassword(
                                    name: _nameTextController.text,
                                    email: _emailTextController.text,
                                    password:
                                    _passwordTextController.text,
                                  );

                                  if (user != null) {
                                    print("ok");
                                    String email = _emailTextController.text;
                                    String name = _nameTextController.text;
                                    String surname = _surnameTextController.text;
                                    String password = _passwordTextController.text;
                                    String tel = _telefonoTextController.text;
                                    final newUser = Utente(email, nome: name, cognome: surname, password: password, telefono: tel, admin: false, listaAttivita: []);
                                    repository.addUtente(newUser);
                                    Navigator.pop(context);
                                  }
                                }*/
                              },
                              child: Text(
                                'Conferma',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}