import 'package:flutter_application_2/common/http_client.dart';
import 'package:flutter_application_2/data/order.dart';
import 'package:flutter_application_2/data/payment_receipt.dart';
import 'package:flutter_application_2/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);
  @override
  Future<SubmitOrderResult> submitOrder(CreateOrderParams params) =>
      dataSource.submitOrder(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) =>
      dataSource.getPaymentReceipt(orderId);

  @override
  Future<List<OrderEntity>> getOrder() {
    return dataSource.getOrder();
  }
}
