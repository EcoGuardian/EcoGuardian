import 'package:ecoguardian/components/CustomAppbar.dart';
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
            CustomAppBar(
              pageTitle: Text(
                'Pregled Kanti',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              isCenter: false,
            ),
          ],
        ),
      ),
    );
  }
}
