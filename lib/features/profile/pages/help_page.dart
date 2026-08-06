import 'package:flutter/material.dart';

import '../widgets/placeholder_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Aide',
      icon: Icons.help_outline,
      message:
          'Consultez bientôt la foire aux questions et contactez notre équipe de support.',
    );
  }
}
