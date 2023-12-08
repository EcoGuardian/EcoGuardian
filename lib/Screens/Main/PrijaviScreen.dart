import 'package:flutter/material.dart';

class PrijaviScreen extends StatelessWidget {
  static const String routeName = '/PrijaviScreen';
  const PrijaviScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('PRIJAVIII'),
          ],
        ),
      ),
    );
  }
}
