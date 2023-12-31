import 'package:flutter/material.dart';

class InputFieldDisabled extends StatelessWidget {
  final MediaQueryData medijakveri;
  final Widget? label;
  final String text;
  final double borderRadijus;
  final double visina;
  final String errorString;
  const InputFieldDisabled({
    super.key,
    required this.medijakveri,
    required this.label,
    required this.text,
    this.borderRadijus = 20,
    this.visina = 10,
    required this.errorString,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.01),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: medijakveri.size.width * 0.01, bottom: medijakveri.size.height * 0.01),
                child: label,
              ),
            ],
          ),
          Container(
            margin: errorString == '' ? EdgeInsets.only(bottom: medijakveri.size.height * 0.019) : EdgeInsets.only(bottom: medijakveri.size.height * 0.01),
            padding: EdgeInsets.only(bottom: visina, top: visina),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadijus),
              color: Colors.white,
              border: errorString == ''
                  ? null
                  : Border.all(
                      color: Colors.red.shade900,
                    ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.04),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
          ),
          if (errorString != '')
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: medijakveri.size.width * 0.04, bottom: medijakveri.size.height * 0.01),
                  child: Text(
                    errorString,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.red.shade900,
                        ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
