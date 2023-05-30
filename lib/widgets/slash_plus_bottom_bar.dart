import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../app/constants.dart';
import '../extensions/build_context_extensions.dart';
import '../extensions/extensions.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';

class SlashPlusBottomBar extends StatelessWidget {
  const SlashPlusBottomBar({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child ?? Container()),
        Container(
          alignment: Alignment.center,
          width: 100.w,
          height: 1.5 * (context.bodySmall?.fontSize).orZero(),
          color: ColorManager.foreground,
          child: RichText(
            text: TextSpan(
              style: context.bodySmall?.copyWith(
                color: ColorManager.background,
                fontSize: FontSize.fs10,
              ),
              children: const [
                TextSpan(text: Constants.poweredBy),
                TextSpan(
                  text: Constants.slashPlus,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
