import 'package:e_commerce_app/features/profile/pages/about_page.dart';
import 'package:e_commerce_app/features/profile/pages/addresses_page.dart';
import 'package:e_commerce_app/features/profile/pages/help_page.dart';
import 'package:e_commerce_app/features/profile/pages/notifications_page.dart';
import 'package:e_commerce_app/features/profile/pages/orders_page.dart';
import 'package:e_commerce_app/features/profile/pages/payment_methods_page.dart';
import 'package:e_commerce_app/features/profile/pages/settings_page.dart';
import 'package:e_commerce_app/features/profile/widgets/placeholder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const cases = [
    (OrdersPage.new, 'Mes commandes', Icons.receipt_long_outlined),
    (AddressesPage.new, 'Adresses', Icons.location_on_outlined),
    (PaymentMethodsPage.new, 'Paiements', Icons.credit_card_outlined),
    (NotificationsPage.new, 'Notifications', Icons.notifications_outlined),
    (SettingsPage.new, 'Paramètres', Icons.settings_outlined),
    (HelpPage.new, 'Aide', Icons.help_outline),
    (AboutPage.new, 'À propos', Icons.info_outline),
  ];

  for (final (page, title, icon) in cases) {
    testWidgets('$title shows an app bar, an illustration and a message', (
      tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: page()));

      expect(find.text(title), findsNWidgets(2));
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.byType(PlaceholderPage), findsOneWidget);
      expect(find.textContaining('bientôt'), findsOneWidget);
    });
  }
}
