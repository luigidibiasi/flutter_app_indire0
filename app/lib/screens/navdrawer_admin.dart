import 'package:flutter/material.dart';

class NavDrawerAdmin extends StatelessWidget {
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