import 'dart:io';

import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PrijaviScreen extends StatefulWidget {
  static const String routeName = '/PrijaviScreen';
  const PrijaviScreen({super.key});

  @override
  State<PrijaviScreen> createState() => _PrijaviScreenState();
}

class _PrijaviScreenState extends State<PrijaviScreen> {
  File? _storedImage;
  Future<void> _takeImage(isCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile;

    imageFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    if (imageFile == null) {
      return;
    }
    CroppedFile? croppedImg = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 344, ratioY: 250),
    );
    if (croppedImg == null) {
      return;
    }
    setState(() {
      _storedImage = File(croppedImg.path);
    });
    setState(() {
      // slikaValidator = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              pageTitle: Text(
                'Prijavite Divlju Deponiju',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              isCenter: false,
              drugaIkonica: Container(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                child: Center(
                  child: Container(
                    child: Icon(
                      TablerIcons.circle_check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              drugaIkonicaFunkcija: () {
                print("PITE");
              },
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            GestureDetector(
              onTap: () {
                Metode.showErrorDialog(
                  isJednoPoredDrugog: true,
                  context: context,
                  naslov: 'Odakle želite da izaberete sliku?',
                  button1Text: 'Kamera',
                  button1Fun: () {
                    _takeImage(true);
                    Navigator.pop(context);
                  },
                  isButton1Icon: true,
                  button1Icon: Icon(
                    TablerIcons.camera,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  isButton2: true,
                  button2Text: 'Galerija',
                  button2Fun: () {
                    _takeImage(false);

                    Navigator.pop(context);
                  },
                  isButton2Icon: true,
                  button2Icon: Icon(
                    TablerIcons.photo,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
              child: Container(
                width: medijakveri.size.width,
                height: medijakveri.size.width * 0.48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Center(
                    child: _storedImage != null
                        ? Image.file(
                            _storedImage!,
                            fit: BoxFit.fill,
                            width: medijakveri.size.width,
                            height: medijakveri.size.width * 0.48,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                TablerIcons.photo,
                                size: 35,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Dodajte sliku',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
