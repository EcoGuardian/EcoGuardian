import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

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

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(218, 236, 222, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            //key: _form,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.07),
              child: Column(
                children: [
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                  Text(
                    'Registrujte se',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                  InputField(
                    isMargin: true,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    hintText: 'Ime',
                    medijakveri: medijakveri,
                    obscureText: false,
                    onSaved: (p0) {},
                    validator: (p0) {},
                    isLabel: true,
                    borderRadijus: 10,
                    label: 'Ime',
                    hintTextSize: 16,
                  ),
                  InputField(
                    isMargin: true,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    hintText: 'Prezime',
                    medijakveri: medijakveri,
                    obscureText: false,
                    onSaved: (p0) {},
                    validator: (p0) {},
                    isLabel: true,
                    borderRadijus: 10,
                    label: 'Prezime',
                    hintTextSize: 16,
                  ),
                  InputField(
                    isMargin: true,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.emailAddress,
                    hintText: 'Email',
                    medijakveri: medijakveri,
                    obscureText: false,
                    onSaved: (p0) {},
                    validator: (p0) {},
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
                    validator: (p0) {},
                    onSaved: (p0) {},
                    isMargin: true,
                    hintTextSize: 16,
                    label: 'Šifra',
                    borderRadijus: 10,
                    isLabel: true,
                    focusNode: pass1Node,
                    onChanged: (p0) {},
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(pass2Node);
                    },
                  ),
                  InputField(
                    medijakveri: medijakveri,
                    hintText: 'Potvrdite šifru',
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    obscureText: true,
                    validator: (p0) {},
                    onSaved: (p0) {},
                    isMargin: true,
                    hintTextSize: 16,
                    label: 'Šifra',
                    borderRadijus: 10,
                    isLabel: true,
                    focusNode: pass2Node,
                    onChanged: (p0) {},
                    onFieldSubmitted: (_) {},
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                  Button(
                    borderRadius: 10,
                    visina: 18,
                    fontsize: 18,
                    buttonText: 'Registrujte se',
                    textColor: Colors.white,
                    isBorder: false,
                    backgroundColor: Theme.of(context).primaryColor,
                    isFullWidth: false,
                    funkcija: () {},
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: Text(
                        'Već reciklirate kao odgovoran građanin?',
                        style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}