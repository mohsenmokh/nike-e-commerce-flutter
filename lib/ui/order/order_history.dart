import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/common/utils.dart';
import 'package:flutter_application_2/data/repo/order_repository.dart';
import 'package:flutter_application_2/ui/order/bloc/order_history_bloc.dart';
import 'package:flutter_application_2/ui/widgets/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryBloc(orderRepository),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('سوابق سفارش'),
            centerTitle: true,
          ),
          body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
              builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: Theme.of(context).dividerColor)),
                      child: Column(
                        children: [
                          Container(
                            height: 56,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('شناسه سفارش'),
                                Text(order.id.toString())
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Container(
                            height: 56,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('مبلغ'),
                                Text(order.payablePrice.withPriceLabel)
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          SizedBox(
                            height: 132,
                            child: ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                scrollDirection: Axis.horizontal,
                                itemCount: order.products.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(
                                        left: 4, right: 4),
                                    child: ImageLoadingService(
                                        imageUrl:
                                            order.products[index].imageUrl,
                                        borderRadius: BorderRadius.circular(8)),
                                  );
                                }),
                          )
                        ],
                      ),
                    );
                  });
            } else if (state is OrderHistroryError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is OrderHistoryLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception('state is not valid');
            }
          })),
    );
  }
}
