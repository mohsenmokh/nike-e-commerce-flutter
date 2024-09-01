import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/common/http_client.dart';
import 'package:flutter_application_2/data/cart.response.dart';
import 'package:flutter_application_2/data/add.to.cart.response.dart';
import 'package:flutter_application_2/data/source/cart_data_source.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  static ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);
  final ICartDataSource dataSource;

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) =>
      dataSource.changeCount(cartItemId, count);

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartItemCountNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) => dataSource.delete(cartItemId);

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
