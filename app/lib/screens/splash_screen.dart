import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/services/secure_storage.dart';
import 'package:flutter_app2/models/storageitem.dart';
import '../../repository/data_repository.dart';
import 'package:flutter_app2/models/utente.dart';

DataRepository repository = DataRepository();
/*final newUser = Utente('admin', nome:'Maria', cognome: 'Natale', email: 'maria_girl.98@hotmail.it', password:'maria',
telefono: '333544', admin: true, listaAttivita: []);*/


class SplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}
class _MySplashScreenState extends State<SplashScreen> {
  final StorageService _storageService = StorageService();
  var _items;
  String route = '/login';

  @override
  void initState() {
    super.initState();
    _checkStorage();
    Timer(Duration(seconds: 3), () => {Navigator.pushReplacementNamed(context, route)});
  }

  @override
  Widget build(BuildContext context) {
    final StorageService _storageService = StorageService();


    return Material(
        color: Colors.white,
      child: InkWell(
        onTap: () {
          //repository.addUtente(newUser);
          print(route);
          Navigator.pushReplacementNamed(context, route);
          },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset('assets/img/logo.png',
              width: 110.0, height: 110.0),
        ),
      ),
    );
  }

  Future<void> _checkStorage() async{
    _items = await _storageService.readAllSecureData();
    for (StorageItem s in _items){
      if (s.key == 'admin' && s.value == 'true') {
        route = '/menu_admin';
      }
      else if (s.key == 'admin' && s.value == 'false'){
        route = '/menu_utente';
      }
    }

  }
}
