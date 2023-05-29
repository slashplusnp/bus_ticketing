import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/string_manager.dart';
import 'custom_filled_button.dart';
import 'widget_utils/widget_utils.dart';

class SaveResetCancelButtons extends StatelessWidget {
  const SaveResetCancelButtons({
    super.key,
    this.saveTitle,
    required this.onSave,
    this.onReset,
    this.onCancel,
  });

  final String? saveTitle;
  final void Function()? onSave;
  final void Function()? onReset;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomFilledButton(
            onPressed: onSave,
            backgroundColor: context.primary,
            title: saveTitle ?? AppString.save,
          ),
        ),
        if (onReset != null) ...[
          WidgetUtils.horizontalSpace(AppDefaults.contentPadding),
          Expanded(
            child: CustomFilledButton(
              onPressed: onReset,
              backgroundColor: ColorManager.foreground,
              title: AppString.reset,
            ),
          ),
        ],
        if (onCancel != null) ...[
          WidgetUtils.horizontalSpace(AppDefaults.contentPadding),
          Expanded(
            child: CustomFilledButton(
              onPressed: onCancel,
              backgroundColor: ColorManager.foreground,
              title: AppString.cancel,
            ),
          ),
        ]
      ],
    );
  }
}
