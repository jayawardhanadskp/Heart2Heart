import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paint/firebase_options.dart';
import 'package:paint/pages/login_page.dart';
import 'package:paint/providers/auth_provider.dart';
import 'package:paint/providers/drawing_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GFAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DrawingProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/', // Starting route
      onGenerateRoute: (RouteSettings settings) {
        // Check the route name and return appropriate route
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => MyHomePage());
          case '/profile':
            // Passing arguments to ProfilePage
            final String userId = settings.arguments as String;
            // return MaterialPageRoute(
              // builder: (context) => ProfilePage(userId: userId),
            // );
          default:
            return MaterialPageRoute(builder: (context) => LoginPage());
        }
      },
    );
  }
}
