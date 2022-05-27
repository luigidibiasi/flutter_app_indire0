import 'package:flutter/material.dart';
import 'package:flutter_app2/services/secure_storage.dart';

class NavDrawerUser extends StatelessWidget {
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
                color: const Color.fromRGBO(222,165,13, .8),
                ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.pushNamed(context, '/menu_user')},
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
            title: Text('Credits'),
            onTap: () => {Navigator.pushNamed(context, '/webview')},
          ),
        ],
      ),
    );
  }
}