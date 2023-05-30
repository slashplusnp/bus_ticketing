import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.value,
  });

  final double? value;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
    );
  }
}
