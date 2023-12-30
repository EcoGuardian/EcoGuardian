import 'package:flutter/material.dart';

class PrijavaViewScreen extends StatefulWidget {
  static const String routeName = '/PrijavaViewScreen';

  const PrijavaViewScreen({super.key});

  @override
  State<PrijavaViewScreen> createState() => _PrijavaViewScreenState();
}

class _PrijavaViewScreenState extends State<PrijavaViewScreen> {
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
