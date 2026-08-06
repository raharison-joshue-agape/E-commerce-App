import 'package:flutter/material.dart';

abstract final class AppDialogService {
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'Annuler',
    String confirmLabel = 'Confirmer',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}
