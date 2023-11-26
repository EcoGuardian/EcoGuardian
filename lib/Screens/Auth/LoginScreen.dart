import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:ecoguardian/Screens/Auth/ForgottenPasswordScreen.dart';
import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/register';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();

  @override
  final pass1Node = FocusNode();

  bool isPassHidden = true;
  void changePassVisibility() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

  final pass2Node = FocusNode();

  bool isPassHidden2 = true;
  void changePassVisibility2() {
    setState(() {
      isPassHidden2 = !isPassHidden2;
    });
  }


  final GlobalKey resetPassKey = GlobalKey();
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _form,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                  Text(
                    'Prijavite se',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                  InputField(
                    isMargin: true,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.emailAddress,
                    hintText: 'Email',
                    medijakveri: medijakveri,
                    obscureText: false,
                    onSaved: (value) {},
                    validator: (value) {},
                    isLabel: true,
                    borderRadijus: 10,
                    label: 'Email',
                    hintTextSize: 16,
                  ),
                  InputField(
                    medijakveri: medijakveri,
                    hintText: 'Šifra',
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {},
                    onSaved: (value) {},
                    isMargin: false,
                    hintTextSize: 16,
                    label: 'Šifra',
                    borderRadijus: 10,
                    isLabel: true,
                    focusNode: pass1Node,
                    onChanged: (value) {},
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(pass2Node);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        key: resetPassKey,
                        onPressed: () {
                          final RenderBox renderBox = resetPassKey.currentContext?.findRenderObject() as RenderBox;
                          final Size size = renderBox.size;
                          final Offset offset = renderBox.localToGlobal(Offset.zero);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (context, animation, duration) => CircularRevealAnimation(
                                animation: animation,
                                centerOffset: Offset(offset.dx + size.width * 0.5, offset.dy + size.height),
                                child: ForgottenPasswordScreen(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Zaboravili ste šifru?',
                          style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                  Button(
                    borderRadius: 10,
                    visina: 18,
                    fontsize: 18,
                    buttonText: 'Prijavite se',
                    textColor: Theme.of(context).colorScheme.primary,
                    isBorder: true,
                    backgroundColor: Colors.white,
                    isFullWidth: false,
                    funkcija: () {},
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Text(
                      'Napravite novi nalog!',
                      style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
