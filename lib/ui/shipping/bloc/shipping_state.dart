part of 'shipping_bloc.dart';

sealed class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

final class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingError extends ShippingState {
  final AppException exception;

  const ShippingError(this.exception);
  @override
  List<Object> get props => [exception];
}

class ShippingSuccess extends ShippingState {
  final SubmitOrderResult data;

  const ShippingSuccess(this.data);
  @override
  List<Object> get props => [data];
}
