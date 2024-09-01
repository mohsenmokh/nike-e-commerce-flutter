import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/common/exceptions.dart';
import 'package:flutter_application_2/data/order.dart';
import 'package:flutter_application_2/data/repo/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository orderRepository;
  ShippingBloc(this.orderRepository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrder) {
        try {
          emit(ShippingLoading());
          final result = await orderRepository.submitOrder(event.params);
          emit(ShippingSuccess(result));
        } catch (e) {
          emit(ShippingError(AppException()));
        }
      }
    });
  }
}
