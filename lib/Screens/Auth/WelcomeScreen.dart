import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = '/WelcomeScreen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('ANES'),
          ],
        ),
      ),
    );
  }
}
