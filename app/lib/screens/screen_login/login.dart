import 'package:flutter/material.dart';
import 'package:flutter_app2/models/storageitem.dart';
import '../../models/utente.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/services/secure_storage.dart';

DataRepository repository = DataRepository();
//final newUser = Utente('admin', nome:'Maria', cognome: 'Natale', email: 'maria_girl.98@hotmail.it', password:'maria',
  //telefono: '333544', admin: true, listaAttivita: []);

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accedi")),
      body: Center(
          child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.all(30),
              child: Padding(
                padding: EdgeInsets.all(20),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(30),
                        child: Image.asset('assets/img/logo.png',
                          fit: BoxFit.contain,
                          width: 200,),
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
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
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
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            print(usernameController.text);
                            print(passwordController.text);
                            var result = repository.checkCredentials(usernameController.text, passwordController.text);
                            Utente? utente = await result;
                            if (utente!= null){
                              StorageItem itemUsername = StorageItem('username', usernameController.text);
                              StorageItem itemPassword = StorageItem('password', passwordController.text);
                              _storageService.writeSecureData(itemUsername);
                              _storageService.writeSecureData(itemPassword);
                              if (utente.admin!) {
                                print(utente.admin);
                                StorageItem itemAdmin = StorageItem('admin', 'true');
                                _storageService.writeSecureData(itemAdmin);
                                Navigator.pushNamed(context, '/menu_admin');
                              }
                              else{
                                StorageItem itemAdmin = StorageItem('admin', 'false');
                                _storageService.writeSecureData(itemAdmin);
                                Navigator.pushNamed(context, '/menu_utente');
                              }
                            }
                            else{
                              _showErrorDialog();
                            }
                          },
                          child: Text("Login"),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Hai bisogno di aiuto?'),
                          TextButton(
                            child: Text(
                                'Contattataci',
                                style: Theme.of(context).textTheme.bodyText2),
                            onPressed: (){
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  )
              ),
          )
      )
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


