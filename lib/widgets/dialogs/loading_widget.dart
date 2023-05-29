import 'dart:async';

import 'package:flutter/material.dart';

import 'loading_widget_controller.dart';

class LoadingWidget {
  LoadingWidget._sharedInstance();
  static final LoadingWidget _shared = LoadingWidget._sharedInstance();
  factory LoadingWidget.instance() => _shared;

  LoadingWidgetController? controller;

  void hide() {
    controller?.close();
    controller = null;
  }

  void show({
    required BuildContext context,
    required Widget content,
  }) {
    hide();
    if (controller?.update(content) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        content: content,
      );
    }
  }

  void showLoading({
    required BuildContext context,
    required String text,
  }) {
    show(
      context: context,
      content: LoadingOverlay(loadingText: text),
    );
  }

  LoadingWidgetController showOverlay({
    required BuildContext context,
    required Widget content,
  }) {
    final contentStream = StreamController<Widget>();
    contentStream.add(content);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: content,
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingWidgetController(
      close: () {
        contentStream.close();
        overlay.remove();
        return true;
      },
      update: (content) {
        contentStream.add(content);
        return true;
      },
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.loadingText,
  });

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
          // Lottie.asset(
          //   assetManager.loadingBusJson,
          //   width: 150,
          //   fit: BoxFit.fitWidth,
          //   delegates: LottieDelegates(
          //     values: [
          //       ValueDelegate.color(
          //         // keyPath order: ['layer name', 'group name', 'shape name']
          //         const ['**', 'Body', '**'],
          //         value: Theme.of(context).primaryColor,
          //       ),
          //       ValueDelegate.color(
          //         // keyPath order: ['layer name', 'group name', 'shape name']
          //         const ['**', 'Window', '**'],
          //         value: const Color.fromARGB(255, 219, 219, 219),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 20),

          Text(
            loadingText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
