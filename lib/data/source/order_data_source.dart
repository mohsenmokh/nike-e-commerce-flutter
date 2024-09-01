import 'package:dio/dio.dart';
import 'package:flutter_application_2/data/order.dart';
import 'package:flutter_application_2/data/payment_receipt.dart';

abstract class IOrderDataSource {
  Future<SubmitOrderResult> submitOrder(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(int orderId);
  Future<List<OrderEntity>> getOrder();
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);
  @override
  Future<SubmitOrderResult> submitOrder(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'mobile': params.phoneNumber,
      'postal_code': params.postalCode,
      'address': params.address,
      'payment_mehtod': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery'
    });
    return SubmitOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrder() async {
    final response = await httpClient.get('order/list');
    return (response.data as List).map((e) => OrderEntity.fromJson(e)).toList();
  }
}
