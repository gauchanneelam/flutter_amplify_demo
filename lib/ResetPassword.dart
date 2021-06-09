import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_aws_cognito/VerifyPassword.dart';
import 'package:flutter_aws_cognito/main.dart';
import 'HomePage.dart';
import 'main.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _email = TextEditingController();
  String _errorMsg = "";
  bool isLoading = false;

  _resetPassword() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        ResetPasswordResult res = await Amplify.Auth.resetPassword(
          username: _email.text.replaceAll(new RegExp(r"\s+"), ""),
        );
        if (!res.isPasswordReset) {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyPassword(),
                settings: RouteSettings(
                  arguments: _email.text.replaceAll(new RegExp(r"\s+"), ""),
                ),
              ));
        }
      } on UserNotFoundException catch (e) {
        setState(() {
          _errorMsg =
              "Cannot reset password for the user as there is no registered/verified email";
          isLoading = false;
        });
      } on InvalidParameterException catch (e) {
        setState(() {
          _errorMsg =
              "Cannot reset password for the user as there is no registered/verified email";
          isLoading = false;
        });
      } on LimitExceededException catch (e) {
        setState(() {
          _errorMsg = "Attempt limit exceeded, please try after some time";
          isLoading = false;
        });
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
                  padding: const EdgeInsets.only(top: 60.0),
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
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Text(
                    "Please provide you email to enter your password.",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
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
                        hintText: 'Enter your email'),
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
                      _resetPassword();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Next',
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
