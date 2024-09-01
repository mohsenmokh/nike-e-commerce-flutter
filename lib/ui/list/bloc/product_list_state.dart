part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
  final int sort;
  final List<ProductEntity> products;
  final List<String> sortNames;

  const ProductListSuccess(this.sort, this.products, this.sortNames);
  @override
  List<Object> get props => [products, sort, sortNames];
}

class ProductListError extends ProductListState {
  final AppException exception;

  const ProductListError(this.exception);
  @override
  List<Object> get props => [exception];
}

class ProductListEmpty extends ProductListState {
  final String message;

  const ProductListEmpty(this.message);
  @override
  List<Object> get props => [message];
}
