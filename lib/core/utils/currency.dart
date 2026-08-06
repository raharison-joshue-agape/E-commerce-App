import 'package:intl/intl.dart';

final NumberFormat _euroFormat = NumberFormat('#,##0.00', 'en_US');

String formatPrice(double amount) {
  final formatted = _euroFormat.format(amount);
  return '${formatted.replaceAll(',', ' ').replaceAll('.', ',')} €';
}
