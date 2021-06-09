import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_aws_cognito/main.dart';
import 'HomePage.dart';
import 'main.dart';

class VerifyPassword extends StatefulWidget {
  @override
  _VerifyPasswordState createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _confirmationCode = TextEditingController();
  var _newPassword = TextEditingController();
  String _errorMsg = "";
  bool isLoading = false;

  _verifyPassword(email) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        final res = await Amplify.Auth.confirmPassword(
            username: email,
            newPassword: _newPassword.text,
            confirmationCode:
                _confirmationCode.text.replaceAll(new RegExp(r"\s+"), ""));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MyApp(),
            ));
      } on CodeMismatchException catch (e) {
        setState(() {
          _errorMsg = "Code is incorrect";
          isLoading = false;
        });
      } on LimitExceededException catch (e) {
        setState(() {
          _errorMsg = "Attempt limit exceeded, please try after some time";
          isLoading = false;
        });
        // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on AuthException catch (e) {
        setState(() {
          _errorMsg = e.message;
          isLoading = false;
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
          title: Text("Reset Password"),
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "A code has been sent to your email. Please change your password using that code.",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    controller: _newPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New password',
                        hintText: 'Enter new password'),
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
                      _verifyPassword(email);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        isLoading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 1,
                              )
                            : Container()
                      ],
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
