import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/storageitem.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/services/secure_storage.dart';
import 'package:flutter_app2/services/validator.dart';
import 'package:flutter_app2/services/fire_auth.dart';

DataRepository repository = DataRepository();

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  final StorageService _storageService = StorageService();
  final _formKey = GlobalKey<FormState>();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Utente? utente =  await repository.getByEmail(_emailTextController.text);
      if (utente!=null && utente.admin!) {
        Navigator.pushNamed(context, '/menu_admin');
      }
      else{
        Navigator.pushNamed(context, '/menu_utente');
      }
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accedi")),
      body: Padding(
          padding: const EdgeInsets.all(50),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: Image.asset('assets/img/logo.png',
                  fit: BoxFit.contain,
                  width: 200,),
              ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                  labelText: 'Email',
                ),
                  validator: (value) => Validator.validateEmail(email: value!),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordTextController,
                  focusNode: _focusPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
                    labelText: 'Password',
                  ),
                  validator: (value) => Validator.validatePassword(password: value!),
                ),
              ],
            ),
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          User? user = await FireAuth.signInUsingEmailPassword(
                            email: _emailTextController.text.trim(),
                            password: _passwordTextController.text.trim(), context: context,
                          );
                          if (user != null) {
                            Utente? utente =  await repository.getByEmail(_emailTextController.text.trim());
                            if (utente!=null && utente.admin!) {
                              Navigator.pushReplacementNamed(context, '/menu_admin');
                            }
                            else{
                              Navigator.pushReplacementNamed(context, '/menu_utente');
                            }
                          }
                          else{
                            _showErrorDialog();
                          }
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void _showErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: new Text('Warning'),
          content: new Text('Username e/o password errati'),
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


