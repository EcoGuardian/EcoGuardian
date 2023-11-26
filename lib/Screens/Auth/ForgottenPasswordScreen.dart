import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:ecoguardian/components/button.dart';
import 'package:ecoguardian/components/inputField.dart';
import 'package:ecoguardian/screens/auth/LoginScreen.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotten-password';

  @override
  State<ForgottenPasswordScreen> createState() => _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> with SingleTickerProviderStateMixin {

  //final GlobalKey registerKey = GlobalKey();
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

  _showModal(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 24),
            child: Text(
              'Zahtjev za resetovanje šifre je poslat na unešenu email adresu.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.009),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'U redu',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.2),
                  Text(
                    'Reset šifre',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.15),
                  InputField(
                    isMargin: true,
                    inputAction: TextInputAction.done,
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
                  SizedBox(height: (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.top) * 0.07),
                  Button(
                    borderRadius: 10,
                    visina: 18,
                    fontsize: 18,
                    buttonText: 'Pošaljite zahtjev',
                    textColor: Colors.white,
                    isBorder: false,
                    backgroundColor: Theme.of(context).primaryColor,
                    isFullWidth: false,
                    funkcija: () {
                      _showModal(context);
                    },
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                child: TextButton(
                  key: loginKey,
                  onPressed: () {
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
                          child: LoginScreen(),
                        ),
                      ),
                    );
                    //Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Text(
                    'Nazad na prijavu',
                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}