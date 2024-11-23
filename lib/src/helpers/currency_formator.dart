import 'package:intl/intl.dart';

final formatCurrencyUs =
NumberFormat.currency(locale: 'en', symbol: '\$ ', decimalDigits: 0);

final formatCurrencyId =
NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

int moneyUs(int money) {
  String hasil = NumberFormat.currency(locale: 'en', symbol: '\$ ', decimalDigits: 0).format(money);
  money = hasil as int;
  return money;
}