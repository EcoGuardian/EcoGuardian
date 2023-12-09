import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class NalogItemCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function funkcija;
  const NalogItemCard({
    super.key,
    required this.icon,
    required this.text,
    required this.funkcija,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => funkcija(),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
            Icon(
              TablerIcons.square_chevron_right,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
