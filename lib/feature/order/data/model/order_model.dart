import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? orderId;
  final String? orderName;
  final String? orderUserId;
  final String? status;
  final DateTime? orderDate;
  final double? orderLatitude;
  final double? orderLongitude;
  final double? userLatitude;
  final double? userLongitude;

  OrderModel({
    this.orderId,
    this.orderName,
    this.orderUserId,
    this.orderDate,
    this.orderLatitude,
    this.orderLongitude,
    this.userLatitude,
    this.userLongitude,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'orderUserId': orderUserId,
      'orderDate': orderDate!.toIso8601String(),
      'orderLatitude': orderLatitude,
      'orderLongitude': orderLongitude,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
      'status': status,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;

    if (json['orderDate'] != null) {
      if (json['orderDate'] is String) {
        parsedDate = DateTime.parse(json['orderDate']);
      } else if (json['orderDate'] is Timestamp) {
        parsedDate = (json['orderDate'] as Timestamp).toDate();
      }
    }

    return OrderModel(
      orderId: json['orderId'],
      orderName: json['orderName'],
      orderUserId: json['orderUserId'],
      orderDate: parsedDate,
      orderLatitude: (json['orderLatitude'] != null)
          ? (json['orderLatitude'] as num).toDouble()
          : null,
      orderLongitude: (json['orderLongitude'] != null)
          ? (json['orderLongitude'] as num).toDouble()
          : null,
      userLatitude: json['userLatitude'],
      userLongitude: json['userLongitude'],
      status: json['status'],
    );
  }
}
