import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:iPizzo/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Authentication a = Authentication();


  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: "assets/images/chili_nbg.png",
      onLogin: (LoginData data) => a.logIn(data.name, data.password),
      onConfirmSignup: (code, data) => a.confirmUser(data.name, code),
      onResendCode: (data) => a.resendCode(data.name.toString()),
      onRecoverPassword: (email) => a.forgotPassword(email),
      onSignup: (SignupData data) => a.signUp(data.name.toString(), data.password.toString()),
    );
  }
}


// riccardi.working@gmail.com
// zimhub@maillinator.com