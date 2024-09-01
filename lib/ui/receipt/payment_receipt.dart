import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/common/utils.dart';
import 'package:flutter_application_2/data/repo/order_repository.dart';
import 'package:flutter_application_2/theme.dart';
import 'package:flutter_application_2/ui/receipt/bloc/payment_receipt_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReceiptScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
      ),
      body: BlocProvider(
        create: (context) => PaymentReceiptBloc(orderRepository)
          ..add(PaymentReceiptStarted(orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
            builder: (context, state) {
          if (state is PaymentReceiptSuccess) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: themeData.dividerColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        state.paymentReceiptData.purchaseSuccess
                            ? 'پرداخت با موفقیت انجام شد'
                            : 'پرداخت ناموفق',
                        style: themeData.textTheme.titleLarge!
                            .apply(color: themeData.colorScheme.primary),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'وضعیت سفارش',
                            style: TextStyle(
                                color: LightThemeColors.secondaryTextColor),
                          ),
                          Text(
                            state.paymentReceiptData.purchaseStatus,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                      const Divider(
                        height: 32,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'مبلغ',
                            style: TextStyle(
                                color: LightThemeColors.secondaryTextColor),
                          ),
                          Text(
                            state
                                .paymentReceiptData.payablePrice.withPriceLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('بازگشت به صفحه اصلی'))
              ],
            );
          } else if (state is PaymentReceiptLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is PaymentReceiptError) {
            return Center(
              child: Text(state.exception.message),
            );
          } else {
            throw Exception('state is not valid');
          }
        }),
      ),
    );
  }
}
