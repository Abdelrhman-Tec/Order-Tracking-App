import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';
import 'package:order_tracking_app/feature/order/data/model/order_model.dart';

class OrderRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<String, String>> createOrder(OrderModel order) async {
    try {
      await firestore.collection('orders').doc(order.orderId).set({
        'orderId': order.orderId,
        'orderName': order.orderName,
        'orderUserId': order.orderUserId,
        'orderDate': Timestamp.fromDate(order.orderDate!),
        'orderLatitude': order.orderLatitude,
        'orderLongitude': order.orderLongitude,
        'userLatitude': order.userLatitude,
        'userLongitude': order.userLongitude,
        'status': order.status,
      });
      return Right('Order created successfully');
    } catch (e) {
      return Left('Failed to create order: $e');
    }
  }

  Future<Either<String, List<OrderModel>>> getOrders() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('orders').get();
      List<OrderModel> orders = snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      log("All Orders : $orders");
      return Right(orders);
    } catch (e) {
      return Left('Failed to fetch orders: $e');
    }
  }

  Future<Either<String, OrderModel>> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('orders')
          .doc(orderId)
          .get();
      if (!doc.exists) return Left('Order not found');
      return Right(OrderModel.fromJson(doc.data() as Map<String, dynamic>));
    } catch (e) {
      return Left('Failed to fetch order: $e');
    }
  }

  Future<Either<String, String>> updateOrderStatus({
    required String orderId,
    required String newStatus,
    required double userLatitude,
    required double userLongitude,
  }) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'userLatitude': userLatitude,
        'userLongitude': userLongitude,
      });
      return Right('Order status updated successfully');
    } catch (e) {
      return Left('Failed to update order status: $e');
    }
  }

  Future<Either<String, String>> deleteOrder(String orderId) async {
    try {
      await firestore.collection('orders').doc(orderId).delete();
      return Right('Order deleted successfully');
    } catch (e) {
      return Left('Failed to delete order: $e');
    }
  }
}
