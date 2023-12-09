import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget pageTitle;
  final IconData? prvaIkonica;
  final double? prvaIkonicaSize;
  final Function? prvaIkonicaFunkcija;
  final Widget? drugaIkonica;
  final Function? drugaIkonicaFunkcija;
  final bool isCenter;

  CustomAppBar({
    required this.pageTitle,
    this.prvaIkonica,
    this.prvaIkonicaSize,
    this.prvaIkonicaFunkcija,
    this.drugaIkonica,
    this.drugaIkonicaFunkcija,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return isCenter
        ? SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                top: (medijakveri.size.height - medijakveri.padding.top) * 0.035,
                bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => prvaIkonicaFunkcija!(),
                    child: Icon(
                      prvaIkonica,
                      size: prvaIkonicaSize ?? 34,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: medijakveri.size.width * 0.65,
                    ),
                    child: FittedBox(
                      child: pageTitle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => drugaIkonicaFunkcija!(),
                    child: drugaIkonica,
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                top: (medijakveri.size.height - medijakveri.padding.top) * 0.035,
                bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (prvaIkonica != null)
                        SizedBox(
                          height: 30,
                          width: 25,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => prvaIkonicaFunkcija!(),
                            icon: Icon(
                              prvaIkonica,
                              size: prvaIkonicaSize,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      if (prvaIkonica != null) SizedBox(width: 5),
                      pageTitle,
                    ],
                  ),
                  if (drugaIkonica != null)
                    GestureDetector(
                      onTap: () => drugaIkonicaFunkcija!(),
                      child: drugaIkonica,
                    ),
                ],
              ),
            ),
          );
  }
}
