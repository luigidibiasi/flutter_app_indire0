import 'package:flutter/material.dart';

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  onPressed: (){
                    print(usernameController.text);
                    Navigator.pushNamed(context, '/menu_admin');
                    //DatabaseManagement.checkCredentials(usernameController.text, passwordController.text);
                  },
                  child: Text("Login"),
                ),
              ),
              Row(
                children: <Widget>[
                  const Text('Hai bisogno di aiuto?'),
                  TextButton(
                    child: Text(
                        'Conattataci',
                        style: Theme.of(context).textTheme.bodyText2),
                    onPressed: (){
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          )),
    );
  }
}


