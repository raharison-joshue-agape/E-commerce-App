import 'package:flutter/material.dart';

import '../widgets/placeholder_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Mes commandes',
      icon: Icons.receipt_long_outlined,
      message:
          'Retrouvez bientôt l\'historique et le suivi de toutes vos commandes.',
    );
  }
}
