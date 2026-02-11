import 'package:equatable/equatable.dart';
import 'package:order_tracking_app/feature/order/data/model/order_model.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderLoaded extends OrderState {
  final OrderModel order;

  const OrderLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderSuccess extends OrderState {
  final String message;

  const OrderSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
