import 'package:flutter/material.dart';

class AktivnostiScreen extends StatelessWidget {
  static const String routeName = '/AktivnostiScreen';
  const AktivnostiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('AKTIVNOSTI GOAT'),
          ],
        ),
      ),
    );
  }
}
