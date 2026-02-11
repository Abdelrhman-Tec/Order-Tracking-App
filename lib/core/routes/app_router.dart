import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:order_tracking_app/core/routes/routes.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/register/register_cubit.dart';
import 'package:order_tracking_app/feature/auth/presentation/screens/login/login_screen.dart';
import 'package:order_tracking_app/feature/auth/presentation/screens/register/register_screen.dart';
import 'package:order_tracking_app/feature/order/data/model/order_model.dart';
import 'package:order_tracking_app/feature/order/data/repo/order_repo.dart';
import 'package:order_tracking_app/feature/order/presentation/cubit/order_cubit.dart';
import 'package:order_tracking_app/feature/order/presentation/screens/order_track/order_track_map_screen.dart';
import 'package:order_tracking_app/feature/order/presentation/screens/orders/orders_screen.dart';
import 'package:order_tracking_app/feature/splash/splash_screen.dart';
import 'package:order_tracking_app/feature/home/presentation/screens/home_screen.dart';
import 'package:order_tracking_app/feature/order/presentation/screens/add_order/add_order_screen.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splashScreen,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        name: Routes.splashScreen,
        path: Routes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: Routes.loginScreen,
        path: Routes.loginScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginCubit(),
          child: const LoginScreen(),
        ),
      ),

      GoRoute(
        name: Routes.registerScreen,
        path: Routes.registerScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => RegisterCubit(),
          child: const RegisterScreen(),
        ),
      ),

      GoRoute(
        name: Routes.homeScreen,
        path: Routes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        name: Routes.addOrderScreen,
        path: Routes.addOrderScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => OrderCubit(OrderRepo()),
          child: const AddOrderScreen(),
        ),
      ),

      GoRoute(
        name: Routes.placePickerScreen,
        path: Routes.placePickerScreen,
        builder: (context, state) => const PlacePickerScreen(),
      ),
      GoRoute(
        name: Routes.orderTrackingMapScreen,
        path: Routes.orderTrackingMapScreen,
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return BlocProvider(
            create: (_) => OrderCubit(OrderRepo()),
            child: OrderTrackMapScreen(orderModel: order),
          );
        },
      ),

      GoRoute(
        name: Routes.ordersScreen,
        path: Routes.ordersScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => OrderCubit(OrderRepo()),
          child: const OrdersScreen(),
        ),
      ),
    ],
  );
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Text(
          '404\nPage Not Found',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
