import 'package:ecoguardian/components/CustomAppbar.dart';
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
            CustomAppBar(
              pageTitle: Text(
                'Aktivnosti',
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
