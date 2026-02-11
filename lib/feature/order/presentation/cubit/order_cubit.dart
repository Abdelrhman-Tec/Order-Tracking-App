import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking_app/feature/order/data/model/order_model.dart';
import 'package:order_tracking_app/feature/order/data/repo/order_repo.dart';
import 'package:order_tracking_app/feature/order/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepo _orderRepo;

  OrderCubit(this._orderRepo) : super(const OrderInitial());

  /// Create Order
  Future<void> createOrder(OrderModel order) async {
    emit(const OrderLoading());

    final result = await _orderRepo.createOrder(order);

    result.fold(
      ifLeft: (error) => emit(OrderError(message: error)),
      ifRight: (success) => emit(OrderSuccess(message: success)),
    );
  }

  /// Get All Orders
  Future<void> getOrders() async {
    emit(const OrderLoading());
    try {
      final result = await _orderRepo.getOrders();
      result.fold(
        ifLeft: (error) {
          log("Error loading orders: $error");
          emit(OrderError(message: error));
          log("Error message: $error");
        },

        ifRight: (orders) {
          emit(OrdersLoaded(orders: orders.toList()));
          log('All Orders: ${jsonEncode(orders.toList())}');
        },
      );
    } catch (e) {
      emit(OrderError(message: 'An unexpected error occurred: $e'));
    }
  }

  /// Get Order By ID
  Future<void> getOrderById(String orderId) async {
    emit(const OrderLoading());

    final result = await _orderRepo.getOrderById(orderId);

    result.fold(
      ifLeft: (error) => emit(OrderError(message: error)),
      ifRight: (order) => emit(OrderLoaded(order: order)),
    );
  }

  /// Update Order Status
  Future<void> updateOrder({
    required String orderId,
    String? status,
    required double userLatitude,
    required double userLongitude,
  }) async {
    emit(const OrderLoading());

    final result = await _orderRepo.updateOrderStatus(
      orderId: orderId,
      newStatus: status!,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
    );

    result.fold(
      ifLeft: (error) {
        emit(OrderError(message: error));
        log("Error updating order: $error");
      },
      ifRight: (success) {
        emit(OrderSuccess(message: success));
        log('Order updated successfully: $success');
      },
    );
  }

  /// Delete Order
  Future<void> deleteOrder(String orderId) async {
    emit(const OrderLoading());

    final result = await _orderRepo.deleteOrder(orderId);

    result.fold(
      ifLeft: (error) => emit(OrderError(message: error)),
      ifRight: (success) => emit(OrderSuccess(message: success)),
    );
  }
}
