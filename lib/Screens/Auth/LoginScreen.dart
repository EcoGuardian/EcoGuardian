import 'package:ecoguardian/Screens/Auth/ForgottenPasswordScreen.dart';
import 'package:ecoguardian/Screens/Auth/RegisterScreen.dart';
import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
  final emailNode = FocusNode();

  bool isPassHidden = true;
  void changePassVisibility() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
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
                    Text(
                      'Dobrodošli nazad!',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          InputField(
                            isMargin: true,
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.emailAddress,
                            hintText: 'Email',
                            medijakveri: medijakveri,
                            obscureText: false,
                            onSaved: (value) {},
                            validator: (value) {
                              if (pass1Node.hasFocus) {
                                return null;
                              } else if (value!.isEmpty) {
                                return 'Molimo Vas da unesete email adresu';
                              }
                            },
                            isLabel: true,
                            borderRadijus: 10,
                            label: 'Email',
                            hintTextSize: 16,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.005,
                                    left: medijakveri.size.width * 0.02,
                                  ),
                                  child: Text(
                                    'Šifra',
                                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                                TextFormField(
                                  focusNode: pass1Node,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  obscureText: isPassHidden,
                                  onFieldSubmitted: (_) {},
                                  onChanged: (_) => _form.currentState!.validate(),
                                  validator: (value) {
                                    if (emailNode.hasFocus) {
                                      return null;
                                    } else if (value!.isEmpty) {
                                      return 'Molimo Vas da unesete šifru';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Šifra',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintStyle: Theme.of(context).textTheme.headline4?.copyWith(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                    suffixIcon: pass1Node.hasFocus
                                        ? IconButton(
                                            onPressed: () => changePassVisibility(),
                                            icon: isPassHidden ? const Icon(TablerIcons.eye) : const Icon(TablerIcons.eye_off),
                                          )
                                        : null,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgottenPasswordScreen()));
                                      },
                                      child: Text(
                                        'Zaboravili ste šifru?',
                                        style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
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
          ],
        ),
      ),
    );
  }
}
