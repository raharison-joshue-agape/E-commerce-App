import 'package:flutter/material.dart';

import '../widgets/placeholder_page.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Paiements',
      icon: Icons.credit_card_outlined,
      message:
          'Ajoutez bientôt vos moyens de paiement de manière simple et sécurisée.',
    );
  }
}
