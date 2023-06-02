import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../../resources/color_manager.dart';
import '../../resources/values_manager.dart';

enum PriceSelectionCardSize {
  small(AppSize.s30),
  large(AppSize.s50);

  final double value;
  const PriceSelectionCardSize(this.value);
}

enum PriceSelectionAction { add, remove }

class PriceSelectionCard extends StatelessWidget {
  const PriceSelectionCard({
    super.key,
    this.onTap,
    this.size = PriceSelectionCardSize.small,
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
        height: size.value,
        width: size.value * 1.6,
        decoration: BoxDecoration(
          border: Border.all(
            color: action == PriceSelectionAction.add ? context.primary : ColorManager.remove,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppDefaults.contentBorderRadius)),
        ),
        child: Center(
          child: Text(
            price.toString(),
            style: context.titleSmall,
          ),
        ),
      ),
    );
  }
}
