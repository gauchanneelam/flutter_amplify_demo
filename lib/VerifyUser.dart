import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_aws_cognito/main.dart';
import 'HomePage.dart';
import 'main.dart';

class VerifyUser extends StatefulWidget {
  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _confirmationCode = TextEditingController();
  String _errorMsg = "";

  _verifyUser(email) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: email,
          confirmationCode:
              _confirmationCode.text.replaceAll(new RegExp(r"\s+"), ""),
        );
        if (res.isSignUpComplete) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyApp(),
              ));
        }
      } on CodeMismatchException catch (e) {
        setState(() {
          _errorMsg = e.message;
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
    final email = ModalRoute.of(context)!.settings.arguments;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("User Verification"),
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
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 150,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Text(
                    _errorMsg,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Text(
                    "A code has been sent to your email. Please verify your account.",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _confirmationCode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Code is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Code',
                        hintText: 'Enter code'),
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
                      _verifyUser(email);
                    },
                    child: Text(
                      'Submit',
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
