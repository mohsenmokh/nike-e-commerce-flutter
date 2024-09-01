// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/order.dart';
import 'package:flutter_application_2/data/repo/order_repository.dart';
import 'package:flutter_application_2/ui/cart/price_info.dart';
import 'package:flutter_application_2/ui/payment_webview.dart';
import 'package:flutter_application_2/ui/receipt/payment_receipt.dart';
import 'package:flutter_application_2/ui/shipping/bloc/shipping_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  StreamSubscription? subscription;

  final TextEditingController firstNameController =
      TextEditingController(text: 'سعید');

  final TextEditingController lastNameController =
      TextEditingController(text: 'شاهینی');

  final TextEditingController postalCodeController =
      TextEditingController(text: '1234567890');

  final TextEditingController addressController =
      TextEditingController(text: 'خیابان شهید بهشتی شسیشسیشسشیس');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09121234567');

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            } else if (state is ShippingSuccess) {
              if (state.data.bankGatewayUrl.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentGatewayScreen(
                            bankGatewayUrl: state.data.bankGatewayUrl)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentReceiptScreen(
                          orderId: state.data.orderId,
                        )));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(label: Text('نام')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: lastNameController,
                  decoration:
                      const InputDecoration(label: Text('نام خانوادگی')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(label: Text('شماره تماس')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(label: Text('کد پستی')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(label: Text('آدرس')),
                ),
                const SizedBox(
                  height: 12,
                ),
                PriceInfo(
                    payablePrice: widget.payablePrice,
                    shippingCost: widget.shippingCost,
                    totalPrice: widget.totalPrice),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return state is ShippingLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    BlocProvider.of<ShippingBloc>(context).add(
                                        ShippingCreateOrder(CreateOrderParams(
                                            firstNameController.text,
                                            lastNameController.text,
                                            postalCodeController.text,
                                            phoneNumberController.text,
                                            addressController.text,
                                            PaymentMethod.cashOnDelivery)));
                                  },
                                  child: const Text('پرداخت در محل')),
                              const SizedBox(
                                width: 16,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstNameController.text,
                                          lastNameController.text,
                                          postalCodeController.text,
                                          phoneNumberController.text,
                                          addressController.text,
                                          PaymentMethod.online)));
                                },
                                child: const Text('پرداخت اینترنتی'),
                              ),
                            ],
                          );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
