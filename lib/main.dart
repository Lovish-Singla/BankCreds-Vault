import 'package:bank_credentials/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'local_auth/app_wrapper.dart';

void main() => runApp(AppWrapper());

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank Organisation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
