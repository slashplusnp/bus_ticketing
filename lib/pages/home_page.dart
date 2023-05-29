import 'package:flutter/material.dart';

final homeScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldMessengerKey,
    );
  }
}
