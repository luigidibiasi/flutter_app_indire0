import 'package:flutter/material.dart';
import 'package:flutter_app2/services/secure_storage.dart';

class NavDrawerAdmin extends StatelessWidget {
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                /*image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))*/
                ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.pushNamed(context, '/menu_admin')},
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text('Esci'),
            onTap: () {
              _storageService.deleteAllSecureData();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Impostazioni'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}