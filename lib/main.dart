import 'package:flutter/material.dart';
import 'landing_page.dart';

void main() {
  runApp(UASDApp());
}

class UASDApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UASD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}
