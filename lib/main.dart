import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_aws_cognito/ResetPassword.dart';
import 'package:flutter_aws_cognito/amplifyconfiguration.dart';
import 'HomePage.dart';
import 'SignUp.dart';
import 'ResetPassword.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _email = TextEditingController();
  var _password = TextEditingController();
  String _errorMsg = "";

  @override
  void initState() {
    super.initState();
    configureAmplify();
  }

  void configureAmplify() async {
    if (!mounted) return;
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    Amplify.addPlugins([authPlugin]);
    await Amplify.configure(amplifyconfig);
    _fetchSession();
  }

  void _fetchSession() async {
    try {
      final res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      if (res.isSignedIn) {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new HomePage()),
        );
      }
    } on AuthException catch (e) {}
  }

  void _signInUser() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        SignInResult res = await Amplify.Auth.signIn(
          username: _email.text.replaceAll(new RegExp(r"\s+"), ""),
          password: _password.text,
        );
        if (res.isSignedIn) {
          // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(),
              ));
        }
      } on NotAuthorizedException catch (e) {
        setState(() {
          _errorMsg = "Email or password is incorrect";
        });
      } on UserNotConfirmedException catch (e) {
        setState(() {
          _errorMsg = "Your account is not verified";
        });
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
          title: Text("Login Page"),
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
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your password'),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new ResetPassword()),
                    );
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: FlatButton(
                    onPressed: () {
                      _signInUser();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 130,
                ),
                TextButton(
                  child: Text('New User? Create Account',
                      style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => SignUp()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
