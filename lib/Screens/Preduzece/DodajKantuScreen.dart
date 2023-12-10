import 'package:flutter/material.dart';

class DodajKantuScreen extends StatefulWidget {
  static const String routeName = '/DodajKantuScreen';

  const DodajKantuScreen({super.key});

  @override
  State<DodajKantuScreen> createState() => _DodajKantuScreenState();
}

class _DodajKantuScreenState extends State<DodajKantuScreen> {
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
