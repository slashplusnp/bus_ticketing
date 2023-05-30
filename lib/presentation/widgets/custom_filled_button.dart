import 'package:flutter/material.dart';

import '../../../../app/constants.dart';
import '../../../../extensions/build_context_extensions.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.title,
    this.onPressed,
    this.backgroundColor,
  });

  final String title;
  final void Function()? onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: AppDefaults.padding)),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: context.titleMedium?.copyWith(
          color: context.scaffoldBackground,
        ),
      ),
    );
  }
}
