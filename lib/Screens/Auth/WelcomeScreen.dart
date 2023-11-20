import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:ecoguardian/Screens/Auth/RegisterScreen.dart';
import 'package:ecoguardian/components/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'LoginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/WelcomeScreen';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey registerKey = GlobalKey();
  final GlobalKey loginKey = GlobalKey();
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/Logo.svg',
                    height: medijakveri.size.height * 0.33,
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                  Text(
                    'EcoGuardian',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              Text(
                'Pronađi kante, prijavi otpad, čuvaj planetu',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        key: registerKey,
                        buttonText: 'Registrujte se',
                        borderRadius: 10,
                        visina: 18,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        isBorder: false,
                        funkcija: () {
                          final RenderBox renderBox = registerKey.currentContext?.findRenderObject() as RenderBox;
                          final Size size = renderBox.size;
                          final Offset offset = renderBox.localToGlobal(Offset.zero);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (context, animation, duration) => CircularRevealAnimation(
                                animation: animation,
                                centerOffset: Offset(offset.dx + size.width * 0.5, offset.dy + size.height),
                                child: const RegisterScreen(),
                              ),
                            ),
                          );
                        },
                        isFullWidth: false,
                        sirina: medijakveri.size.width * 0.4,
                      ),
                      Button(
                        key: loginKey,
                        buttonText: 'Prijavite se',
                        borderRadius: 10,
                        visina: 18,
                        backgroundColor: Colors.white,
                        isBorder: true,
                        textColor: Theme.of(context).colorScheme.primary,
                        funkcija: () {
                          final RenderBox renderBox = loginKey.currentContext?.findRenderObject() as RenderBox;
                          final Size size = renderBox.size;
                          final Offset offset = renderBox.localToGlobal(Offset.zero);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (context, animation, duration) => CircularRevealAnimation(
                                animation: animation,
                                centerOffset: Offset(offset.dx + size.width * 0.5, offset.dy + size.height),
                                child: const LoginScreen(),
                              ),
                            ),
                          );
                        },
                        isFullWidth: false,
                        sirina: medijakveri.size.width * 0.4,
                      ),
                    ],
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                  Row(
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
                          style: Theme.of(context).textTheme.headline3?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
