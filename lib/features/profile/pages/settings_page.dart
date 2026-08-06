import 'package:flutter/material.dart';

import '../widgets/placeholder_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Paramètres',
      icon: Icons.settings_outlined,
      message: 'Personnalisez bientôt votre expérience dans l\'application.',
    );
  }
}
