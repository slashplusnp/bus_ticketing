import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../network/error_handler.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

class CustomDialog {
  CustomDialog._sharedInstance();
  static final CustomDialog _shared = CustomDialog._sharedInstance();
  factory CustomDialog.instance() => _shared;

  Future<T?> _showGenericDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    required DialogOptionBuilder<T> optionsBuilder,
    bool barrierDismissible = true,
  }) {
    final options = optionsBuilder();
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final value = options[optionTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle),
            );
          }).toList(),
        );
      },
    );
  }

  Future<bool> showDeleteAccountDialog(BuildContext context) {
    return _showGenericDialog<bool>(
      context: context,
      title: 'Delete account',
      content: 'Are you sure you want to delete your account? You cannot undo this operation!',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete account': true,
      },
    ).then(
      (value) => value ?? false,
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return _showGenericDialog<bool>(
      context: context,
      title: 'Log out',
      content: 'Are you sure you want to log out?',
      optionsBuilder: () => {
        'Cancel': false,
        'Log out': true,
      },
    ).then(
      (value) => value ?? false,
    );
  }

  Future<void> showGeneralPopup(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return _showGenericDialog<bool>(
      context: context,
      title: title,
      content: description,
      optionsBuilder: () => {
        'Ok': true,
      },
    );
  }

  Future<bool> showAppError({
    required BuildContext context,
    required AppError appError,
    String actionText = 'OK',
  }) {
    return _showGenericDialog<bool>(
      context: context,
      title: appError.title,
      content: appError.description,
      optionsBuilder: () => {
        actionText: true,
      },
    ).then((value) => value ?? false);
  }

  Future<void> showServerMaintenanceBreakError({
    required BuildContext context,
    required AppError appError,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: AlertDialog(
            title: Text(appError.title),
            content: Text(appError.description),
            actions: [
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
