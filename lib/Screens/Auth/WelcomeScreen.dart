import 'package:ecoguardian/components/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = '/WelcomeScreen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/Logo.svg',
                height: medijakveri.size.height * 0.33,
              ),
              Center(
                child: Text(
                  'EcoGuardian',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text('Pronađi kante, prijavi otpad, čuvaj planetu', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline2),
              ),
              const SizedBox(height: 107),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    buttonText: 'Registrujte se',
                    borderRadius: 10,
                    visina: 18,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    isBorder: false,
                    funkcija: () {},
                    isFullWidth: false,
                    sirina: medijakveri.size.width * 0.4,
                  ),
                  Button(
                    buttonText: 'Prijavite se',
                    borderRadius: 10,
                    visina: 18,
                    backgroundColor: Colors.white,
                    isBorder: true,
                    textColor: Theme.of(context).colorScheme.primary,
                    funkcija: () {},
                    isFullWidth: false,
                    sirina: medijakveri.size.width * 0.4,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Intelecto',
                          style: Theme.of(context).textTheme.headline3?.copyWith(color: Theme.of(context).colorScheme.primary),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
