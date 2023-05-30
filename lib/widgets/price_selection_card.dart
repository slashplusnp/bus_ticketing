import 'package:flutter/material.dart';

import '../app/constants.dart';
import '../extensions/build_context_extensions.dart';
import '../resources/color_manager.dart';

enum PriceSelectionCardSize {
  small(AppDefaults.contentPadding),
  large(AppDefaults.paddingXXLarge);

  final double value;
  const PriceSelectionCardSize(this.value);
}

enum PriceSelectionAction { add, remove }

class PriceSelectionCard extends StatelessWidget {
  const PriceSelectionCard({
    super.key,
    this.onTap,
    this.size = PriceSelectionCardSize.large,
    this.action = PriceSelectionAction.add,
    required this.price,
  });

  final VoidCallback? onTap;
  final PriceSelectionCardSize size;
  final PriceSelectionAction action;
  final int price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(AppDefaults.contentBorderRadius)),
      child: Container(
        padding: EdgeInsets.all(size.value),
        decoration: BoxDecoration(
          border: Border.all(
            color: action == PriceSelectionAction.add ? context.primary : ColorManager.remove,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppDefaults.contentBorderRadius)),
        ),
        child: Text(
          price.toString(),
          style: context.titleSmall,
        ),
      ),
    );
  }
}
