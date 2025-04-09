import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {
  runApp(const GreenStepsApp());
}

class GreenStepsApp extends StatelessWidget {
  const GreenStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenSteps',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}
