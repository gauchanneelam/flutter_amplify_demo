import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void _logoutSession() async {
    try {
      await Amplify.Auth.signOut();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyApp(),
          ));
    } on AuthException catch (e) {}
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Home Page'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: Container(
                width: 200,
                height: 150,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 60),
            child: Text(
              "Congratulations! You are logged in.",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
          Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: FlatButton(
              onPressed: () {
                _logoutSession();
              },
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
