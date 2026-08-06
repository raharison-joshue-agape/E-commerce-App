import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../../shared/widgets/error_state_widget.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page introuvable')),
      body: ErrorStateWidget(
        icon: Icons.error_outline,
        title: '404 — Page introuvable',
        message: 'La page demandée n\'existe pas ou a été déplacée.',
        actionLabel: 'Retour à l\'accueil',
        actionIcon: Icons.home_outlined,
        onAction: () => context.go(AppRoutes.home),
      ),
    );
  }
}
