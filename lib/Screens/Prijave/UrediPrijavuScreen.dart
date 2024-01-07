import 'dart:io';

import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class UrediPrijavuScreen extends StatefulWidget {
  final String description;
  final DateTime dateTime;
  final String lat;
  final String long;
  final String imageUrl;
  final String status;
  final String id;
  static const String routeName = '/PrijavaEditScreen';

  const UrediPrijavuScreen({
    super.key,
    required this.description,
    required this.dateTime,
    required this.lat,
    required this.long,
    required this.imageUrl,
    required this.status,
    required this.id,
  });

  @override
  State<UrediPrijavuScreen> createState() => _UrediPrijavuScreenState();
}

class _UrediPrijavuScreenState extends State<UrediPrijavuScreen> {
  final _form = GlobalKey<FormState>();

  String? slikaValidator;
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
      slikaValidator = null;
    });
  }

  bool isCurrentPosition = false;
  LatLng currentPosition = LatLng(0, 0);
  List<Type> types = [];
  bool isLoading = false;
  Set<Marker> markers = {};

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentPosition = LatLng(double.parse(widget.lat), double.parse(widget.long));
    markers.add(
      Marker(
        markerId: MarkerId(
          DateTime.now().toIso8601String(),
        ),
        position: LatLng(double.parse(widget.lat), double.parse(widget.long)),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {
      isCurrentPosition = true;
    });
  }

  String? lokacijaError;

  void submit() async {
    if (_storedImage != null) {
      if (_storedImage!.readAsBytesSync().lengthInBytes / 1048576 >= 3.5) {
        setState(() {
          slikaValidator = 'Molimo Vas da izaberete drugu sliku';
        });
        return;
      }
    }

    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    if (prijavaData['lat'] == widget.lat && prijavaData['long'] == widget.long && prijavaData['opis'] == widget.description && _storedImage == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<GeneralProvider>(context, listen: false)
          .urediPrijavu(
        id: int.parse(widget.id),
        lat: prijavaData['lat']!,
        long: prijavaData['long']!,
        description: prijavaData['opis']!,
        image: _storedImage,
      )
          .then((value) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              content: Text(
                'Uspješno ste uredili prijavu!',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
        context: context,
        naslov: 'Došlo je do greške',
        button1Text: 'Zatvori',
        button1Fun: () {
          Navigator.pop(context);
        },
        isButton2: false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    prijavaData['lat'] = widget.lat;
    prijavaData['long'] = widget.long;
    prijavaData['opis'] = widget.description;
  }

  Map<String, String> prijavaData = {
    'lat': '',
    'long': '',
    'opis': '',
  };

  GoogleMapController? yourMapController;

  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map_style.json").then((value) => setMapStyle(value, mapController));
  }

  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100, (medijakveri.size.height - medijakveri.padding.top) * 0.9),
          child: CustomAppBar(
            pageTitle: Text(
              'Uredite Prijavu',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            isCenter: true,
            horizontalMargin: 0.06,
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
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.pop(context);
            },
            drugaIkonica: isLoading
                ? const SizedBox(
                    height: 33,
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Icon(
                      TablerIcons.circle_check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
            drugaIkonicaFunkcija: () {
              submit();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
            child: Column(
              children: [
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
                              )
                            : Image.network(
                                widget.imageUrl,
                                fit: BoxFit.fill,
                                width: medijakveri.size.width,
                              ),
                      ),
                    ),
                  ),
                ),
                if (slikaValidator != null) SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                if (slikaValidator != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        slikaValidator!,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ],
                  ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                Row(
                  children: [
                    Text(
                      "Promijenite lokaciju divlje deponije",
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                isCurrentPosition
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: (medijakveri.size.height - medijakveri.padding.top) * 0.4,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: currentPosition,
                              zoom: 15,
                            ),
                            onMapCreated: (GoogleMapController c) {
                              yourMapController = c;
                              changeMapMode(yourMapController!);
                            },
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                            },
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            onTap: (position) {
                              setState(() {
                                markers.clear();
                                markers.add(
                                  Marker(
                                    markerId: MarkerId(
                                      DateTime.now().toIso8601String(),
                                    ),
                                    position: position,
                                    icon: BitmapDescriptor.defaultMarker,
                                  ),
                                );
                                prijavaData['lat'] = position.latitude.toString();
                                prijavaData['long'] = position.longitude.toString();
                                lokacijaError = null;
                              });
                            },
                            markers: markers,
                          ),
                        ),
                      )
                    : Container(
                        height: (medijakveri.size.height - medijakveri.padding.top) * 0.4,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                if (lokacijaError != null)
                  Row(
                    children: [
                      Text(
                        lokacijaError!,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ],
                  ),
                if (lokacijaError != null) SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                Button(
                  buttonText: 'Trenutna lokacija',
                  borderRadius: 10,
                  visina: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  isBorder: false,
                  funkcija: () {
                    setState(() {
                      markers.clear();
                      markers.add(
                        Marker(
                          markerId: MarkerId(
                            DateTime.now().toIso8601String(),
                          ),
                          position: currentPosition,
                          icon: BitmapDescriptor.defaultMarker,
                        ),
                      );
                      prijavaData['lat'] = currentPosition.latitude.toString();
                      prijavaData['long'] = currentPosition.longitude.toString();
                      lokacijaError = null;
                    });
                  },
                  icon: const Icon(
                    TablerIcons.map_pin_filled,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                Form(
                  key: _form,
                  child: InputField(
                    initalValue: widget.description,
                    isMargin: true,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    hintText: 'Opis',
                    medijakveri: medijakveri,
                    obscureText: false,
                    onSaved: (value) {
                      prijavaData['opis'] = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Molimo Vas da popunite polje';
                      }
                      if (value.length < 3) {
                        return 'Opis je ne može biti manji od 3 karaktera';
                      }
                      if (value.length > 500) {
                        return 'Opis je ne može biti veći od 500 karaktera';
                      }
                      return null;
                    },
                    isLabel: true,
                    borderRadijus: 10,
                    label: Text(
                      'Opis',
                      style: Theme.of(context).textTheme.headline3?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    hintTextSize: 16,
                    brMinLinija: 3,
                    brMaxLinija: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
