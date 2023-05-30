import 'package:flutter/material.dart';

import '../../../../app/constants.dart';
import '../../extensions/extensions.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.buttonColor,
  });

  final Widget title;
  final void Function()? onPressed;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDefaults.contentBorderRadius),
            ),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(buttonColor),
        foregroundColor: buttonColor == null
            ? null
            : MaterialStatePropertyAll(
                (buttonColor?.computeLuminance()).orZero() > 0.5 ? Colors.black : Colors.white,
              ),
      ),
      child: Container(
        alignment: Alignment.center,
        child: title,
      ),
    );
  }
}
