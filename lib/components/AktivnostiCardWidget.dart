import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';

class AktivnostiCardWidget extends StatefulWidget {
  final String title;
  final DateTime dateTime;
  final TimeOfDay time;
  final String location;
  final int participants;

  AktivnostiCardWidget({
    required this.title,
    required this.dateTime,
    required this.time,
    required this.location,
    required this.participants,
  });

  @override
  _AktivnostiCardWidgetState createState() => _AktivnostiCardWidgetState();
}

class _AktivnostiCardWidgetState extends State<AktivnostiCardWidget> {
  bool isJoining = true;

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Column(
        children: [
          Container(
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Vrijeme',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                width: 5,
              ),
              Icon(TablerIcons.clock),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${DateFormat('dd.MM.yyyy.').format(widget.dateTime)} | ${DateFormat('HH:mm').format(widget.dateTime)}",
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Lokacija',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                width: 5,
              ),
              Icon(TablerIcons.map_pin_filled),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(widget.location,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Theme.of(context).primaryColor,
                      )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Broj učesnika: ${widget.participants}",
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                width: 5,
              ),
              Icon(TablerIcons.users),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isJoining = !isJoining;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isJoining ? Theme.of(context).colorScheme.primary : Colors.white,
                    onPrimary: isJoining ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      side: BorderSide(
                        color: isJoining ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isJoining
                          ? Icon(
                              TablerIcons.circle_check,
                              size: 24,
                            )
                          : Icon(
                              TablerIcons.circle_x,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      SizedBox(width: 10),
                      Text(
                        isJoining ? 'Pridruži se' : 'Odustani',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isJoining ? Colors.white : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.015),
        ],
      ),
    );
  }
}
