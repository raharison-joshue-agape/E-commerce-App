import 'package:flutter/material.dart';

import '../widgets/placeholder_page.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Adresses',
      icon: Icons.location_on_outlined,
      message:
          'Gérez bientôt vos adresses de livraison et de facturation en un seul endroit.',
    );
  }
}
