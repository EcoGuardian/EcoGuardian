import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget pageTitle;
  final Widget? prvaIkonica;
  final double? prvaIkonicaSize;
  final Function? prvaIkonicaFunkcija;
  final Widget? drugaIkonica;
  final Function? drugaIkonicaFunkcija;
  final bool isCenter;
  final double? horizontalMargin;

  CustomAppBar({
    required this.pageTitle,
    this.prvaIkonica,
    this.prvaIkonicaSize,
    this.prvaIkonicaFunkcija,
    this.drugaIkonica,
    this.drugaIkonicaFunkcija,
    required this.isCenter,
    this.horizontalMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return isCenter
        ? SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * horizontalMargin!),
              padding: EdgeInsets.only(
                top: (medijakveri.size.height - medijakveri.padding.top) * 0.035,
                bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => prvaIkonicaFunkcija!(),
                    child: prvaIkonica,
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
              margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * horizontalMargin!),
              padding: EdgeInsets.only(
                top: (medijakveri.size.height - medijakveri.padding.top) * 0.035,
                bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (prvaIkonica != null)
                        GestureDetector(
                          onTap: () => prvaIkonicaFunkcija!(),
                          child: prvaIkonica,
                        ),
                      if (prvaIkonica != null) const SizedBox(width: 5),
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
