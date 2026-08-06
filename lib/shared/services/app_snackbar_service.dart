import 'package:flutter/material.dart';

enum AppSnackbarType { info, success, error }

abstract final class AppSnackbarService {
  static void show(
    BuildContext context,
    String message, {
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          backgroundColor: switch (type) {
            AppSnackbarType.success => Colors.green.shade600,
            AppSnackbarType.error => Theme.of(context).colorScheme.error,
            AppSnackbarType.info => null,
          },
        ),
      );
  }
}
