import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();

extension PriceLabel on int {
  String get withPriceLabel =>
      this > 0 ? '$separateByComma this تومان ' : 'رایگان';
  String get separateByComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}
