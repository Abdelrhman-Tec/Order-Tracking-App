import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/constants/colors/app_colors.dart';
import 'package:order_tracking_app/core/constants/style/app_text_style.dart';
import 'package:order_tracking_app/core/routes/routes.dart';
import 'package:order_tracking_app/core/utils/extension.dart';
import 'package:order_tracking_app/core/widgets/custom_button.dart';
import 'package:order_tracking_app/core/widgets/loading_indicator.dart';
import 'package:order_tracking_app/feature/order/data/model/order_model.dart';
import 'package:order_tracking_app/feature/order/presentation/cubit/order_cubit.dart';
import 'package:order_tracking_app/feature/order/presentation/cubit/order_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Icon(Icons.arrow_back_ios, color: AppColors.white),
            ),
            const Spacer(),
            Text(
              'Orders',
              style: AppTextStyle.font18Bold.copyWith(color: AppColors.white),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: LoadingIndicator(color: AppColors.primaryOrange),
            );
          }

          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders yet'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return OrderCard(orderModel: order);
              },
            );
          }

          if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel orderModel;

  const OrderCard({super.key, required this.orderModel});

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<String> getAddress() async {
    if (orderModel.orderLatitude == null || orderModel.orderLongitude == null) {
      return 'Location not available';
    }

    try {
      final placemarks = await placemarkFromCoordinates(
        orderModel.orderLatitude!,
        orderModel.orderLongitude!,
      );
      if (placemarks.isEmpty) return 'Location not available';
      final p = placemarks.first;
      return '${p.street ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}';
    } catch (e) {
      return 'Failed to load location';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatted = orderModel.orderDate != null
        ? DateFormat('dd MMM yyyy • hh:mm a').format(orderModel.orderDate!)
        : 'Unknown date';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order Name + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  orderModel.orderName ?? 'Unnamed Order',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(
                    orderModel.status,
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  orderModel.status ?? 'Unknown',
                  style: TextStyle(
                    color: _statusColor(orderModel.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Order ID
          Text(
            'Order ID: ${orderModel.orderId ?? '--'}',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),

          const SizedBox(height: 12),

          // Date
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(dateFormatted, style: theme.textTheme.bodyMedium),
            ],
          ),

          const SizedBox(height: 12),

          // Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FutureBuilder<String>(
                  future: getAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading location...',
                        style: theme.textTheme.bodyMedium,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Failed to load location',
                        style: theme.textTheme.bodyMedium,
                      );
                    } else {
                      return Text(
                        snapshot.data ?? 'Location not available',
                        style: theme.textTheme.bodyMedium,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: CustomButton(
              text: 'Start Order',
              onPressed: () {
                GoRouter.of(
                  context,
                ).pushNamed(Routes.orderTrackingMapScreen, extra: orderModel);
              },
              width: 200,
              backgroundColor: AppColors.primaryOrange,
            ),
          ),
        ],
      ).paddingSymmetric(h: 15, v: 15),
    );
  }
}
