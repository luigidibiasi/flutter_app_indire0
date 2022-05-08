import 'package:flutter/material.dart';
import 'package:flutter_app2/screens/navdrawer_user.dart';

class MenuUtente extends StatelessWidget{
  const MenuUtente({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        drawer: NavDrawerUser(),
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
                  Container(
                    height: 60,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/home_user');
                      },
                      child: Text("Visualizza attività"),
                    ),
                  ),
                ]
            )
        ),

    );
  }
}