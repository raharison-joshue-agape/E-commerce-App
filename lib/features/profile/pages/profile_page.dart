import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Profil',
      icon: Icons.person_outline,
      message: 'Cette fonctionnalité sera développée prochainement.',
    );
  }
}
