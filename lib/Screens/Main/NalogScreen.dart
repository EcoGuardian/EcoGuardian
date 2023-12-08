import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NalogScreen extends StatelessWidget {
  static const String routeName = '/NalogScreen';
  const NalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('NALOG ALE ALE'),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logOut();
                },
                child: Text('LOG OUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
