import 'package:flutter/material.dart';

class CustomErrorBuilder extends StatelessWidget {
  const CustomErrorBuilder({
    super.key,
    this.error,
  });

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Text(error.toString());
  }
}
