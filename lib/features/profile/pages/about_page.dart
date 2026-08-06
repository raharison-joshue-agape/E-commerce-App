import 'package:flutter/material.dart';

import '../widgets/placeholder_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'À propos',
      icon: Icons.info_outline,
      message:
          'Découvrez bientôt plus d\'informations sur NovaShop et ses engagements.',
    );
  }
}
