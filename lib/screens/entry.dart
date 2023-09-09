import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:iPizzo/utils/colors.dart';
import '../amplifyconfiguration.dart';
import 'package:iPizzo/screens/login.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins(
        [
          AmplifyAuthCognito(),
          AmplifyAnalyticsPinpoint(),
        ],
      );
      await Amplify.configure(amplifyconfig);

      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyException catch (e) {
      safePrint(e.message); //this message work only in debug mode
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bgColor,
              secondaryColor,
            ],
          ),
        ),
        child: Center(
          child: _amplifyConfigured ? Login() : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
