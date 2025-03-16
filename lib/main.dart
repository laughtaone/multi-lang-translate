import 'package:flutter/material.dart';
import 'package:translate/main_page.dart';

void main() {
  runApp(
    const StartPageHome()
  );
}

class StartPageHome extends StatelessWidget {
  const StartPageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
