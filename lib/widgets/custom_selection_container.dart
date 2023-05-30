import 'package:flutter/material.dart';

import '../app/constants.dart';
import '../extensions/build_context_extensions.dart';

class CustomSelectionContainer<T> extends StatelessWidget {
  const CustomSelectionContainer({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.title,
    this.value,
  });

  final void Function(T? value) onTap;
  final bool isSelected;
  final String title;
  final T? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDefaults.contentPaddingXSmall),
      child: InkWell(
        onTap: () => onTap.call(value),
        borderRadius: const BorderRadius.all(Radius.circular(AppDefaults.contentBorderRadius)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding, vertical: AppDefaults.contentPadding),
          decoration: BoxDecoration(
            color: isSelected ? context.primary : null,
            border: Border.all(color: context.primary),
            borderRadius: const BorderRadius.all(Radius.circular(AppDefaults.contentBorderRadius)),
          ),
          child: Text(
            title,
            style: context.titleMedium?.apply(color: isSelected ? context.scaffoldBackground : context.primary),
          ),
        ),
      ),
    );
  }
}
