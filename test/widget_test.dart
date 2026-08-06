import 'package:e_commerce_app/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the home page', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ECommerceApp(),
      ),
    );

    expect(find.text('E-commerce App'), findsOneWidget);
  });
}
