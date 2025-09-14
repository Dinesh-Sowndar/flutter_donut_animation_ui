import 'package:donut_ui_animation/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donut App UI Animation',
      theme: ThemeData(
        primaryColor: const Color(0xFF0A1529),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFFB325),
            secondary: const Color(0xFFFFB325)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}