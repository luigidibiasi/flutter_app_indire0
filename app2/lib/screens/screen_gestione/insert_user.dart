import 'package:flutter/material.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/screens/navdrawer_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app2/services/validator.dart';
import 'package:flutter_app2/services/fire_auth.dart';

DataRepository repository = DataRepository();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _telefonoTextController = TextEditingController();
  final _surnameTextController = TextEditingController();


  final _focusName = FocusNode();
  final _focusSurname = FocusNode();
  final _focusTelefono = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusSurname.unfocus();
        _focusTelefono.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Register'),
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
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value!,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
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
                        controller: _surnameTextController,
                        focusNode: _focusSurname,
                        validator: (value) => Validator.validateName(
                          name: value!,
                        ),
                        decoration: InputDecoration(
                          hintText: "Surname",
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
                                if (_registerFormKey.currentState!
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
                                }
                              },
                              child: Text(
                                'Sign up',
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