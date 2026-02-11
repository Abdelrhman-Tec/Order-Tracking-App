import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracking_app/core/routes/app_router.dart';

class OrderTrackingApp extends StatelessWidget {
  const OrderTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
