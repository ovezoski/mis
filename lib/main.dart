import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/joke_types_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'providers/joke_provider.dart'; //Import your provider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmToken = await FirebaseMessaging.instance.getToken();

  print("FCM TOKEN");
  print(fcmToken);

  runApp(
    ChangeNotifierProvider(
      create: (context) => JokeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const JokeTypesScreen(),
    );
  }
}
