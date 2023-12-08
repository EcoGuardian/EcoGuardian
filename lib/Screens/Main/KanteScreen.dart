import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KanteScreen extends StatelessWidget {
  static const String routeName = '/KanteScreen';
  const KanteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Provider.of<Auth>(context, listen: false).logOut();
              },
              child: Text('KANTE GOAT ISK ISK'),
            ),
          ],
        ),
      ),
    );
  }
}
