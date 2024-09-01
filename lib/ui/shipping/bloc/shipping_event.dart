part of 'shipping_bloc.dart';

sealed class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

class ShippingCreateOrder extends ShippingEvent {
  final CreateOrderParams params;

  const ShippingCreateOrder(this.params);
}
