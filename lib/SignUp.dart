import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'HomePage.dart';
import 'VerifyUser.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _errorMsg = "";
  var _email = TextEditingController();
  var _password = TextEditingController();

  _registerAccount() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        SignUpResult res = await Amplify.Auth.signUp(
          username: _email.text.replaceAll(new RegExp(r"\s+"), ""),
          password: _password.text,
          options: CognitoSignUpOptions(
            userAttributes: {
              "email": _email.text.replaceAll(new RegExp(r"\s+"), "")
            },
          ),
        );
        if (res.isSignUpComplete) {
          // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyUser(),
                settings: RouteSettings(
                  arguments: _email.text.replaceAll(new RegExp(r"\s+"), ""),
                ),
              ));
        }
      } on AuthException catch (e) {
        setState(() {
          _errorMsg = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Create an account"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 150,
                    ),
                  ),
                ),
                Text(
                  _errorMsg,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextFormField(
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your password'),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: FlatButton(
                    onPressed: () {
                      _registerAccount();
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
