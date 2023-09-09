import 'package:flutter/material.dart';
import 'package:iPizzo/screens/entry.dart';
import 'package:iPizzo/screens/home.dart';
import 'package:iPizzo/services/auth.dart';
import 'package:iPizzo/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Authentication a = Authentication();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: EntryScreen(), with this settings we don't need to put a home, because we have a generated route everytime we open the app
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(
              data: settings.arguments.toString(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
          );
        }

        return MaterialPageRoute(builder: (_) => const EntryScreen());
      },
    );
  }
}
