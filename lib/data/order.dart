import 'package:flutter_application_2/data/product.dart';

class SubmitOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  SubmitOrderResult(this.orderId, this.bankGatewayUrl);
  SubmitOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String postalCode;
  final String phoneNumber;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams(this.firstName, this.lastName, this.postalCode,
      this.phoneNumber, this.address, this.paymentMethod);
}

enum PaymentMethod { online, cashOnDelivery }

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> products;

  OrderEntity(this.id, this.payablePrice, this.products);
  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        products = (json['order_items'] as List)
            .map((product) => ProductEntity.fromJson(product['product']))
            .toList();
}
