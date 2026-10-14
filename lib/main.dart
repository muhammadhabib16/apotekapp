import 'package:flutter/material.dart';

import 'screens/daftar_obat_screen.dart';

void main() {
  runApp(const ApotekApp());
}

class ApotekApp extends StatelessWidget {
  const ApotekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apotek App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const DaftarObatScreen(),
    );
  }
}
