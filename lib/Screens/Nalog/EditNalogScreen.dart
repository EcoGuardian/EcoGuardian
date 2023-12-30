import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../components/CustomAppbar.dart';
import '../../components/InputField.dart';

class EditNalogScreen extends StatefulWidget {
  static const String routeName = '/editProfile';
  const EditNalogScreen({Key? key}) : super(key: key);

  @override
  State<EditNalogScreen> createState() => _EditNalogScreenState();
}

class _EditNalogScreenState extends State<EditNalogScreen> {
  Key _form = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  final pass1Node = FocusNode();
  final pass2Node = FocusNode();

  bool isPassHidden = true;
  void changePassVisibility() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

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
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: CustomAppBar(
          prvaIkonica: Container(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                )),
            child: Icon(
              TablerIcons.arrow_big_left_lines,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          prvaIkonicaFunkcija: () {
            Navigator.pop(context);
          },
          pageTitle: Text(
            'Uredite Nalog',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          isCenter: true,
          horizontalMargin: 0.06,
          drugaIkonica: Container(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                )),
            child: Icon(
              TablerIcons.circle_check,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          drugaIkonicaFunkcija: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: SizedBox(
                height: 130,
                width: 130,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://www.google.com/search?sca_esv=588490409&sxsrf=AM9HkKk-JjRVQse3GsJ-3RHngqz43StQIg:1701901947039&q=placeholder+profile+picture&tbm=isch&source=lnms&sa=X&ved=2ahUKEwilp_vn7vuCAxXmwQIHHfEIA5IQ0pQJegQICxAB&cshid=1701901951736261&biw=1440&bih=783&dpr=1#imgrc=QDyv6al4I9VkeM',
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.08),
              width: double.infinity,
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        InputField(
                          isMargin: true,
                          medijakveri: medijakveri,
                          isLabel: true,
                          label: Text(
                            'Ime',
                            style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          kapitulacija: TextCapitalization.sentences,
                          hintText: 'Ime',
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.name,
                          obscureText: false,
                          borderRadijus: 10,
                          visina: 18,
                          validator: (value) {},
                          onSaved: (value) {},
                        ),
                        InputField(
                          isMargin: true,
                          medijakveri: medijakveri,
                          isLabel: true,
                          label: Text(
                            'Prezime',
                            style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          kapitulacija: TextCapitalization.sentences,
                          hintText: 'Prezime',
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.name,
                          obscureText: false,
                          borderRadijus: 10,
                          visina: 18,
                          validator: (value) {},
                          onSaved: (value) {},
                        ),
                        InputField(
                          isMargin: true,
                          isLabel: true,
                          medijakveri: medijakveri,
                          label: Text(
                            'Email',
                            style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          hintText: 'E-mail',
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.emailAddress,
                          obscureText: false,
                          borderRadijus: 10,
                          visina: 18,
                          validator: (value) {},
                          onSaved: (value) {},
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
                                controller: _passwordController,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(pass2Node);
                                },
                                onSaved: (value) {},
                                validator: (value) {},
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
                            ],
                          ),
                        ),
                      ],
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
