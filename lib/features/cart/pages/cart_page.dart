import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../shared/services/app_dialog_service.dart';
import '../../../shared/services/app_snackbar_service.dart';
import '../providers/cart_providers.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';
import '../widgets/checkout_bar.dart';
import '../widgets/empty_cart_widget.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Panier',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: EmptyCartWidget(
          onContinueShopping: () => context.go(AppRoutes.products),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panier',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _confirmClearCart(context, ref),
            icon: const Icon(Icons.delete_sweep_outlined),
            label: const Text('Vider'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final item in cart.items) CartItemCard(item: item),
          CartSummary(
            itemCount: cart.itemCount,
            subtotal: cart.subtotal,
            total: cart.total,
          ),
        ],
      ),
      bottomNavigationBar: CheckoutBar(
        total: cart.total,
        onCheckout: () => _showComingSoon(context),
      ),
    );
  }

  Future<void> _confirmClearCart(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppDialogService.showConfirm(
      context,
      title: 'Vider le panier',
      message: 'Voulez-vous vraiment retirer tous les articles ?',
      confirmLabel: 'Oui',
    );

    if (confirmed == true) {
      ref.read(cartProvider.notifier).clearCart();
    }
  }

  void _showComingSoon(BuildContext context) {
    AppSnackbarService.show(context, 'Le paiement sera bientôt disponible.');
  }
}
