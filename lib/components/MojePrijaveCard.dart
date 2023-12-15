import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';

class MojeAktivnostiCard extends StatefulWidget {
  final String description;
  final DateTime dateTime;
  final TimeOfDay time;
  final String location;
  final String? image;

  MojeAktivnostiCard({
    required this.description,
    required this.dateTime,
    required this.time,
    required this.location,
    this.image
  });

  @override
  _MojeAktivnostiCardState createState() => _MojeAktivnostiCardState();
}

class _MojeAktivnostiCardState extends State<MojeAktivnostiCard> {

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy.');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.12),
      child: Column(
        children: [
          Center(
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.green),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 0, maxHeight: double.infinity),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Image.asset(
                          widget.image!,
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.location,
                              style: Theme.of(context).textTheme.headline4?.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(widget.description, style: Theme.of(context).textTheme.headline4,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${dateFormat.format(widget.dateTime)} | ${widget.time.format(context)}",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                PopupMenuButton(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(TablerIcons.edit),
                                            SizedBox(width: 8),
                                            Text('Izmijeni prijavu'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(TablerIcons.trash_x),
                                            SizedBox(width: 8),
                                            Text('Obriši prijavu'),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected: (value) {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary,
                                // onPrimary: isJoining ? Colors.white : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(TablerIcons.circle_check, size: 24, color: Colors.white,),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'Riješeno',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.015),
        ],
      ),
    );
  }
}
