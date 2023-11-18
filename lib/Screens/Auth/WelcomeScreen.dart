import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
              // SvgPicture.asset('/images/Logo.svg', width: 100, height: 100),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 80, 0, 25),
                  child: Image.asset('images/Logo.png')
              ),
              Center(
                child: Text(
                  'EcoGuardian',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Pronađi kante, prijavi otpad, čuvaj planetu',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2
                ),
              ),
              const SizedBox(height: 107),
              Center(
                child: Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 160,
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Registrujte se',
                          style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white)
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 60,
                      width: 160,
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary
                          )
                        ),
                        child: Text(
                            'Registrujte se',
                            style: Theme.of(context).textTheme.headline4
                        ),
                      ),
                    ),
                  ],
                ),
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
                       onPressed: (){},
                       child: Text(
                         'Intelecto',
                          style: Theme.of(context).textTheme.headline3?.copyWith(color: Theme.of(context).colorScheme.primary),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
